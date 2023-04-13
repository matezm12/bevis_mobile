# bevis

A new Flutter project.

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://flutter.dev/docs/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://flutter.dev/docs/cookbook)

For help getting started with Flutter, view our
[online documentation](https://flutter.dev/docs), which offers tutorials,
samples, guidance on mobile development, and a full API reference.

Build production Android Bundle command:

    flutter build appbundle --no-sound-null-safety
    flutter build ios
    flutter build ipa
    
Deploy to web version to AWS:

    cd web
    aws s3 sync ./ s3://app.bevis.sg/ --cache-control=max-age=3600 --acl=public-read --delete
    aws cloudfront create-invalidation --distribution-id E20HI65QFTSR7Z --paths "/*"

