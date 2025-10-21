#!/usr/bin/env python3
"""
StitchMe Device Controller - Main Application
Runs on the physical StitchMe device (Raspberry Pi/Jetson Nano)

This is the native app that controls the physical device:
- Motor control for treatment application
- Sensor data collection (cameras, vitals)
- Communication with mobile/desktop apps
- Device status display on built-in screen
- Safety systems and emergency stops
"""

import asyncio
import logging
import signal
import sys
from datetime import datetime
from pathlib import Path

# Device modules
from device_controller import DeviceController
from sensor_manager import SensorManager
from communication_manager import CommunicationManager
from ui_manager import UIManager
from safety_manager import SafetyManager

# Configure logging
logging.basicConfig(
    level=logging.INFO,
    format='%(asctime)s - %(name)s - %(levelname)s - %(message)s',
    handlers=[
        logging.FileHandler('/var/log/stitchme/device.log'),
        logging.StreamHandler(sys.stdout)
    ]
)

logger = logging.getLogger(__name__)

class StitchMeDevice:
    """Main device application controller"""
    
    def __init__(self):
        self.running = False
        self.device_controller = None
        self.sensor_manager = None
        self.communication_manager = None
        self.ui_manager = None
        self.safety_manager = None
        
    async def initialize(self):
        """Initialize all device subsystems"""
        try:
            logger.info("🏥 Starting StitchMe Device Controller...")
            
            # Initialize safety systems first
            self.safety_manager = SafetyManager()
            await self.safety_manager.initialize()
            logger.info("✅ Safety systems initialized")
            
            # Initialize hardware controllers
            self.device_controller = DeviceController()
            await self.device_controller.initialize()
            logger.info("✅ Device controller initialized")
            
            # Initialize sensors (cameras, vitals, etc.)
            self.sensor_manager = SensorManager()
            await self.sensor_manager.initialize()
            logger.info("✅ Sensor systems initialized")
            
            # Initialize communication (Bluetooth, WiFi)
            self.communication_manager = CommunicationManager()
            await self.communication_manager.initialize()
            logger.info("✅ Communication systems initialized")
            
            # Initialize device UI (touchscreen display)
            self.ui_manager = UIManager()
            await self.ui_manager.initialize()
            logger.info("✅ Device UI initialized")
            
            # Run system diagnostics
            await self.run_diagnostics()
            
            logger.info("🚀 StitchMe Device ready for operation!")
            return True
            
        except Exception as e:
            logger.error(f"❌ Device initialization failed: {e}")
            await self.emergency_shutdown()
            return False
    
    async def run_diagnostics(self):
        """Run comprehensive system diagnostics"""
        logger.info("🔍 Running system diagnostics...")
        
        # Check all critical systems
        diagnostics = {
            'motors': await self.device_controller.test_motors(),
            'cameras': await self.sensor_manager.test_cameras(),
            'sensors': await self.sensor_manager.test_sensors(),
            'communication': await self.communication_manager.test_connectivity(),
            'safety': await self.safety_manager.test_safety_systems(),
            'storage': await self.check_storage_space(),
        }
        
        # Log results
        for system, status in diagnostics.items():
            status_icon = "✅" if status else "❌"
            logger.info(f"{status_icon} {system.capitalize()}: {'OK' if status else 'FAILED'}")
        
        # Check if any critical systems failed
        critical_systems = ['motors', 'safety', 'cameras']
        failed_critical = [sys for sys in critical_systems if not diagnostics[sys]]
        
        if failed_critical:
            logger.error(f"❌ Critical systems failed: {failed_critical}")
            await self.safety_manager.enter_safe_mode()
            raise Exception(f"Critical system failure: {failed_critical}")
    
    async def check_storage_space(self):
        """Check available storage space"""
        try:
            import shutil
            total, used, free = shutil.disk_usage("/")
            free_gb = free // (1024**3)
            
            if free_gb < 1:  # Less than 1GB free
                logger.warning(f"⚠️ Low storage space: {free_gb}GB free")
                return False
            
            logger.info(f"💾 Storage: {free_gb}GB free")
            return True
            
        except Exception as e:
            logger.error(f"❌ Storage check failed: {e}")
            return False
    
    async def main_loop(self):
        """Main device operation loop"""
        self.running = True
        
        while self.running:
            try:
                # Update device status
                await self.update_device_status()
                
                # Process incoming commands from mobile/desktop apps
                await self.communication_manager.process_commands()
                
                # Update sensor readings
                await self.sensor_manager.update_readings()
                
                # Update device UI
                await self.ui_manager.update_display()
                
                # Check safety systems
                await self.safety_manager.monitor_safety()
                
                # Small delay to prevent CPU overload
                await asyncio.sleep(0.1)
                
            except Exception as e:
                logger.error(f"❌ Error in main loop: {e}")
                await self.safety_manager.handle_error(e)
    
    async def update_device_status(self):
        """Update overall device status"""
        status = {
            'timestamp': datetime.now().isoformat(),
            'device_id': await self.get_device_id(),
            'status': 'operational',
            'connected_apps': await self.communication_manager.get_connected_devices(),
            'sensor_readings': await self.sensor_manager.get_current_readings(),
            'system_health': await self.get_system_health(),
        }
        
        # Broadcast status to connected apps
        await self.communication_manager.broadcast_status(status)
    
    async def get_device_id(self):
        """Get unique device identifier"""
        try:
            # Use MAC address or serial number
            import uuid
            return str(uuid.getnode())
        except:
            return "unknown-device"
    
    async def get_system_health(self):
        """Get overall system health metrics"""
        try:
            import psutil
            
            return {
                'cpu_percent': psutil.cpu_percent(),
                'memory_percent': psutil.virtual_memory().percent,
                'temperature': await self.get_cpu_temperature(),
                'uptime': datetime.now().timestamp() - psutil.boot_time(),
            }
        except:
            return {'status': 'unknown'}
    
    async def get_cpu_temperature(self):
        """Get CPU temperature (Raspberry Pi specific)"""
        try:
            with open('/sys/class/thermal/thermal_zone0/temp', 'r') as f:
                temp = int(f.read().strip()) / 1000.0
                return temp
        except:
            return None
    
    async def emergency_shutdown(self):
        """Emergency shutdown procedure"""
        logger.error("🚨 EMERGENCY SHUTDOWN INITIATED")
        
        try:
            # Stop all motors immediately
            if self.device_controller:
                await self.device_controller.emergency_stop()
            
            # Activate safety systems
            if self.safety_manager:
                await self.safety_manager.emergency_mode()
            
            # Notify connected apps
            if self.communication_manager:
                await self.communication_manager.broadcast_emergency()
            
            # Update device display
            if self.ui_manager:
                await self.ui_manager.show_emergency_screen()
            
        except Exception as e:
            logger.error(f"❌ Error during emergency shutdown: {e}")
        
        finally:
            self.running = False
    
    async def graceful_shutdown(self):
        """Graceful shutdown procedure"""
        logger.info("🔄 Graceful shutdown initiated...")
        
        try:
            # Stop main loop
            self.running = False
            
            # Safely stop all systems
            if self.device_controller:
                await self.device_controller.shutdown()
            
            if self.sensor_manager:
                await self.sensor_manager.shutdown()
            
            if self.communication_manager:
                await self.communication_manager.shutdown()
            
            if self.ui_manager:
                await self.ui_manager.shutdown()
            
            if self.safety_manager:
                await self.safety_manager.shutdown()
            
            logger.info("✅ StitchMe Device shutdown complete")
            
        except Exception as e:
            logger.error(f"❌ Error during shutdown: {e}")

def signal_handler(signum, frame):
    """Handle system signals for graceful shutdown"""
    logger.info(f"📡 Received signal {signum}, initiating shutdown...")
    asyncio.create_task(device.graceful_shutdown())

async def main():
    """Main entry point"""
    global device
    
    # Set up signal handlers
    signal.signal(signal.SIGINT, signal_handler)
    signal.signal(signal.SIGTERM, signal_handler)
    
    # Create and initialize device
    device = StitchMeDevice()
    
    try:
        # Initialize all systems
        if await device.initialize():
            # Run main operation loop
            await device.main_loop()
        else:
            logger.error("❌ Device initialization failed")
            sys.exit(1)
            
    except KeyboardInterrupt:
        logger.info("🛑 Keyboard interrupt received")
    except Exception as e:
        logger.error(f"❌ Unexpected error: {e}")
        await device.emergency_shutdown()
    finally:
        await device.graceful_shutdown()

if __name__ == "__main__":
    # Ensure we're running as root for hardware access
    import os
    if os.geteuid() != 0:
        logger.error("❌ This application must be run as root for hardware access")
        sys.exit(1)
    
    # Run the main application
    asyncio.run(main())
