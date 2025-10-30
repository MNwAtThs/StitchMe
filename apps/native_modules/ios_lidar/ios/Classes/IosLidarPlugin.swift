import Flutter
import UIKit
import ARKit
import RealityKit

public class IosLidarPlugin: NSObject, FlutterPlugin {
    private var arSession: ARSession?
    private var isScanning = false
    private var depthData: [Float] = []
    
    public static func register(with registrar: FlutterPluginRegistrar) {
        let channel = FlutterMethodChannel(name: "stitchme/lidar", binaryMessenger: registrar.messenger())
        let instance = IosLidarPlugin()
        registrar.addMethodCallDelegate(instance, channel: channel)
    }
    
    public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        switch call.method {
        case "isLiDARAvailable":
            result(ARWorldTrackingConfiguration.supportsSceneReconstruction(.mesh))
        case "startScanning":
            startLiDARScanning(result: result)
        case "stopScanning":
            stopLiDARScanning(result: result)
        case "captureData":
            captureDepthData(result: result)
        default:
            result(FlutterMethodNotImplemented)
        }
    }
    
    private func startLiDARScanning(result: @escaping FlutterResult) {
        guard ARWorldTrackingConfiguration.supportsSceneReconstruction(.mesh) else {
            result(FlutterError(code: "LIDAR_NOT_AVAILABLE", message: "LiDAR not available on this device", details: nil))
            return
        }
        
        arSession = ARSession()
        let configuration = ARWorldTrackingConfiguration()
        
        if ARWorldTrackingConfiguration.supportsSceneReconstruction(.mesh) {
            configuration.sceneReconstruction = .mesh
        }
        
        arSession?.run(configuration)
        isScanning = true
        
        result(["status": "started", "timestamp": Date().timeIntervalSince1970])
    }
    
    private func stopLiDARScanning(result: @escaping FlutterResult) {
        arSession?.pause()
        arSession = nil
        isScanning = false
        depthData.removeAll()
        
        result(["status": "stopped", "timestamp": Date().timeIntervalSince1970])
    }
    
    private func captureDepthData(result: @escaping FlutterResult) {
        guard isScanning, let session = arSession else {
            result(FlutterError(code: "NOT_SCANNING", message: "LiDAR scanning not active", details: nil))
            return
        }
        
        guard let frame = session.currentFrame else {
            result([])
            return
        }
        
        // Extract depth data from ARFrame
        var capturedData: [[String: Any]] = []
        
        if let sceneDepth = frame.sceneDepth {
            let depthMap = sceneDepth.depthMap
            let confidenceMap = sceneDepth.confidenceMap
            
            // Convert depth data to array of points
            // This is a simplified version - in production you'd want more sophisticated processing
            let width = CVPixelBufferGetWidth(depthMap)
            let height = CVPixelBufferGetHeight(depthMap)
            
            CVPixelBufferLockBaseAddress(depthMap, .readOnly)
            defer { CVPixelBufferUnlockBaseAddress(depthMap, .readOnly) }
            
            let depthPointer = unsafeBitCast(CVPixelBufferGetBaseAddress(depthMap), to: UnsafeMutablePointer<Float32>.self)
            
            // Sample every 10th pixel to reduce data size
            for y in stride(from: 0, to: height, by: 10) {
                for x in stride(from: 0, to: width, by: 10) {
                    let index = y * width + x
                    let depth = depthPointer[index]
                    
                    if depth > 0 && depth < 5.0 { // Filter reasonable depth values (0-5 meters)
                        capturedData.append([
                            "x": x,
                            "y": y,
                            "depth": depth,
                            "timestamp": Date().timeIntervalSince1970
                        ])
                    }
                }
            }
        }
        
        result(capturedData)
    }
}


