from flask import Flask, request
import subprocess
import os

app = Flask(__name__)

@app.route('/deploy', methods=['POST'])
def deploy():
    try:
        # Run PowerShell deploy script
        result = subprocess.run(["powershell.exe", "-ExecutionPolicy", "Bypass", ".\\deploy.ps1"], capture_output=True, text=True)
        return {
            "status": "success",
            "stdout": result.stdout,
            "stderr": result.stderr
        }, 200
    except Exception as e:
        return {"status": "error", "message": str(e)}, 500

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5000)
