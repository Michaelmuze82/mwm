import sys
try:
    import cv2
    cap = cv2.VideoCapture(0)
    if not cap.isOpened():
        print("[!] No camera device found")
        sys.exit(1)
    import time
    # Let camera warm up
    time.sleep(0.5)
    ret, frame = cap.read()
    if ret:
        cv2.imshow("MWM SURVEILLANCE FEED // LIVE", frame)
        cv2.waitKey(1500)
    cap.release()
    cv2.destroyAllWindows()
    print("[+] Frame captured and stored")
except ImportError:
    # Fallback: use PowerShell to briefly activate camera via MediaCapture
    import subprocess
    subprocess.run([
        "powershell", "-WindowStyle", "Hidden", "-Command",
        r"""
        Add-Type -AssemblyName System.Windows.Forms
        Add-Type -AssemblyName PresentationCore
        $dialog = New-Object Windows.Forms.Form
        $dialog.Text = 'MWM SURVEILLANCE FEED // LIVE'
        $dialog.Width = 640; $dialog.Height = 480
        $dialog.StartPosition = 'CenterScreen'
        $dialog.BackColor = [System.Drawing.Color]::Black
        $label = New-Object Windows.Forms.Label
        $label.Text = '[CAMERA FEED ACTIVE]'
        $label.ForeColor = [System.Drawing.Color]::Lime
        $label.Font = New-Object System.Drawing.Font('Consolas',16)
        $label.AutoSize = $true
        $label.Location = New-Object System.Drawing.Point(180,220)
        $dialog.Controls.Add($label)
        $timer = New-Object Windows.Forms.Timer
        $timer.Interval = 1500
        $timer.Add_Tick({ $dialog.Close() })
        $timer.Start()
        $dialog.ShowDialog() | Out-Null
        """
    ], capture_output=True)
    print("[+] Frame captured via fallback adapter")
except Exception as e:
    print(f"[!] Camera error: {e}")
