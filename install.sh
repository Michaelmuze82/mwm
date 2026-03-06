#!/bin/bash
# MWM Framework Installer - Linux/Mac/Git Bash

RED='\033[0;31m'
GREEN='\033[0;32m'
WHITE='\033[1;37m'
CYAN='\033[0;36m'
NC='\033[0m'

echo ""
echo -e "${RED}  ███╗   ███╗${WHITE}██╗    ██╗${RED}███╗   ███╗${NC}"
echo -e "${RED}  ████╗ ████║${WHITE}██║    ██║${RED}████╗ ████║${NC}"
echo -e "${RED}  ██╔████╔██║${WHITE}██║ █╗ ██║${RED}██╔████╔██║${NC}"
echo -e "${RED}  ██║╚██╔╝██║${WHITE}██║███╗██║${RED}██║╚██╔╝██║${NC}"
echo -e "${RED}  ██║ ╚═╝ ██║${WHITE}╚███╔███╔╝${RED}██║ ╚═╝ ██║${NC}"
echo -e "${RED}  ╚═╝     ╚═╝${WHITE} ╚══╝╚══╝ ${RED}╚═╝     ╚═╝${NC}"
echo ""
echo -e "  ${WHITE}MWM Framework Installer${NC}"
echo ""

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"

# Detect OS
if [[ "$OSTYPE" == "msys" || "$OSTYPE" == "cygwin" || "$OSTYPE" == "win32" ]]; then
    PLATFORM="windows"
elif [[ "$OSTYPE" == "darwin"* ]]; then
    PLATFORM="mac"
else
    PLATFORM="linux"
fi

echo -e "  ${GREEN}[+]${NC} Platform: $PLATFORM"
echo -e "  ${GREEN}[+]${NC} Source: $SCRIPT_DIR"

# Make mwm.sh executable
chmod +x "$SCRIPT_DIR/mwm.sh" 2>/dev/null

# Install opencv
if command -v python3 &>/dev/null; then
    echo -e "  ${GREEN}[+]${NC} Found Python3"
    echo -e "  ${CYAN}[*]${NC} Installing opencv-python..."
    python3 -m pip install opencv-python --quiet 2>/dev/null && \
        echo -e "  ${GREEN}[+]${NC} opencv-python installed" || \
        echo -e "  ${CYAN}[~]${NC} opencv skipped (webcam will use fallback)"
elif command -v python &>/dev/null; then
    echo -e "  ${GREEN}[+]${NC} Found Python"
    python -m pip install opencv-python --quiet 2>/dev/null
fi

# Create symlink or wrapper
if [[ "$PLATFORM" == "windows" ]]; then
    # On Git Bash on Windows, create wrapper in ~/bin
    mkdir -p "$HOME/bin"
    cat > "$HOME/bin/mwm" << WRAPPER
#!/bin/bash
bash "$SCRIPT_DIR/mwm.sh" "\$@"
WRAPPER
    chmod +x "$HOME/bin/mwm"
    echo -e "  ${GREEN}[+]${NC} Wrapper created: ~/bin/mwm"

    # Check PATH
    if [[ ":$PATH:" != *":$HOME/bin:"* ]]; then
        echo 'export PATH="$HOME/bin:$PATH"' >> "$HOME/.bashrc" 2>/dev/null
        echo 'export PATH="$HOME/bin:$PATH"' >> "$HOME/.bash_profile" 2>/dev/null
        echo -e "  ${GREEN}[+]${NC} Added ~/bin to PATH in .bashrc"
    fi
else
    # Linux/Mac - symlink to /usr/local/bin or ~/bin
    if [ -w /usr/local/bin ]; then
        ln -sf "$SCRIPT_DIR/mwm.sh" /usr/local/bin/mwm
        echo -e "  ${GREEN}[+]${NC} Symlinked to /usr/local/bin/mwm"
    else
        mkdir -p "$HOME/bin"
        ln -sf "$SCRIPT_DIR/mwm.sh" "$HOME/bin/mwm"
        echo -e "  ${GREEN}[+]${NC} Symlinked to ~/bin/mwm"
        if [[ ":$PATH:" != *":$HOME/bin:"* ]]; then
            echo 'export PATH="$HOME/bin:$PATH"' >> "$HOME/.bashrc" 2>/dev/null
            echo -e "  ${GREEN}[+]${NC} Added ~/bin to PATH"
        fi
    fi
fi

echo ""
echo -e "  ${WHITE}══════════════════════════════════════════════${NC}"
echo -e "  ${GREEN}Installation complete!${NC}"
echo ""
echo -e "  Usage:"
echo -e "    ${CYAN}mwm${NC}           Launch interactive shell"
echo -e "    ${CYAN}mwm help${NC}      Show all commands"
echo -e "    ${CYAN}mwm scan${NC}      Network scan"
echo -e "    ${CYAN}mwm cam${NC}       Webcam capture"
echo ""
echo -e "  Open a new terminal, then type: ${WHITE}mwm${NC}"
echo -e "  ${WHITE}══════════════════════════════════════════════${NC}"
echo ""
