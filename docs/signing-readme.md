# fix signing issues / prepare action secrets
We hebben nodig een p12 file uit je keychain.app

Hiervoor moeten we een op de huidige mac aangevraagd certificaat hebben

- keychain.app
- menu bar -> certificate assistant -> request from a certificate authority (name eg: timmerdorp 2024)
- save to disk
- use certificate request file to create certificate in developer.apple.com -> certificates (ios distribution app store)

Hiermee vervolgens een provisioning profile aanmaken

https://appstoreconnect.apple.com/access/api -> appstore connect api key (note issuer and keyid in `/fastlane/Fastfile`)
upload base64 variants to github actions secrets

### secrets example:

| ENV | Value |
| --------------- | --------------- |
| `PARSE_APP_ID` | parse server value |
| `PARSE_JS_KEY` | parse server value |
| `MOBILEPROVISION_BASE64` | file to base64 string |
| `P12_BASE64` | file to base64 string |
| `APPSTORE_CONNECT_KEY` | file to base64 string |

#### Commands
- `cat TimmerdorpApp2024.mobileprovision | base64`
- `cat Certificates.p12 | base64`
- `cat AuthKey_****.p8 | base64`
