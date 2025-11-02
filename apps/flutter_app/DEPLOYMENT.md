# StitchMe Flutter Web Deployment Guide

## 🚀 Deploy to Vercel

### Prerequisites
- Vercel account (free tier available)
- GitHub repository with your code
- Supabase project set up

### Quick Deploy Steps

1. **Push to GitHub**
   ```bash
   git add .
   git commit -m "Add Vercel deployment configuration"
   git push origin main
   ```

2. **Connect to Vercel**
   - Go to [vercel.com](https://vercel.com)
   - Click "New Project"
   - Import your GitHub repository
   - Select the `apps/flutter_app` directory as the root

3. **Configure Build Settings**
   - Framework Preset: `Other`
   - Build Command: `./build.sh`
   - Output Directory: `build/web`
   - Install Command: `echo "Dependencies handled by build script"`

4. **Set Environment Variables**
   In Vercel dashboard, add these environment variables:
   ```
   SUPABASE_URL=your_supabase_project_url
   SUPABASE_ANON_KEY=your_supabase_anon_key
   FLUTTER_WEB=true
   ```

5. **Deploy**
   - Click "Deploy"
   - Wait for build to complete
   - Your app will be available at `https://your-project.vercel.app`

### Alternative: Vercel CLI

```bash
# Install Vercel CLI
npm i -g vercel

# Navigate to flutter app directory
cd apps/flutter_app

# Deploy
vercel --prod
```

### Build Locally (Optional)

```bash
# Build for web
flutter build web --release

# Test locally
cd build/web
python -m http.server 8080
```

### Troubleshooting

**Build Fails:**
- Check Flutter version compatibility
- Ensure all dependencies are compatible with web
- Check build logs for specific errors

**App Doesn't Load:**
- Verify base href configuration
- Check browser console for errors
- Ensure Supabase credentials are correct

**Camera/LiDAR Features:**
- These features are limited on web
- Consider showing appropriate fallbacks
- Test on mobile browsers for better experience

### Performance Optimization

1. **Enable Web Optimizations**
   ```bash
   flutter build web --release --dart-define=FLUTTER_WEB_USE_SKIA=false
   ```

2. **Optimize Assets**
   - Compress images in `web/icons/`
   - Minimize custom fonts
   - Use web-optimized image formats

3. **Configure Caching**
   - Vercel automatically handles caching
   - Consider service worker for offline support

### Security Notes

- Never commit `.env` files with real credentials
- Use Vercel environment variables for secrets
- Enable HTTPS (automatic with Vercel)
- Configure CORS properly in Supabase

### Custom Domain (Optional)

1. In Vercel dashboard, go to Project Settings
2. Click "Domains"
3. Add your custom domain
4. Configure DNS records as instructed

---

**Need Help?**
- Check Vercel documentation: https://vercel.com/docs
- Flutter web docs: https://docs.flutter.dev/platform-integration/web
- StitchMe issues: Create an issue in the repository
