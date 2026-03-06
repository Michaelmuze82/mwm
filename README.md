# MWM Framework

A fake "hacker" terminal that looks terrifying but does absolutely nothing destructive.

Pulls real system data (ports, IPs, users, connections) and mixes it with fake hacking animations for maximum effect. **No actual changes are ever made to any system.**

## Install

### Windows (requires [Git for Windows](https://git-scm.com/download/win))

```
git clone <your-repo-url> mwm-framework
cd mwm-framework
install.bat
```

### Linux / Mac

```bash
git clone <your-repo-url> mwm-framework
cd mwm-framework
chmod +x install.sh
./install.sh
```

## Usage

```
mwm              # Interactive shell with mwm> prompt
mwm help          # Show all commands
mwm scan          # Network scan (shows REAL ports & connections)
mwm bypass        # Auth bypass with password cracking animation
mwm cam           # Opens webcam for ~1.5 sec then closes
mwm exploit       # Fake remote code execution
mwm keylog        # Fake keystroke capture
mwm inject        # Fake SQL injection
mwm trace         # Fake network route trace
mwm decrypt       # Fake AES decryption
mwm exfil         # Fake data exfiltration
mwm wifi          # Fake wireless AP scan
```

Commands accept extra words and still work:
```
mwm cam hack backdoor force access    # still just runs cam
mwm bypass mainframe security grid    # still just runs bypass
```

## Features

- Periodic "session re-auth" prompts (accepts any input)
- Real system info mixed with fake data
- Webcam actually opens briefly (requires Python + opencv-python)
- Works on Windows (Git Bash), Linux, and Mac
- Cool ASCII art and animations

## Requirements

- **Git Bash** (Windows) or any bash shell (Linux/Mac)
- **Python 3** (optional, for webcam feature)
- **opencv-python** (optional, auto-installed by installer)

## Disclaimer

This is a novelty/prank tool. It performs no actual hacking, exploitation, or system modification. All "results" are fake or read-only system queries. Use responsibly.
