node {
    docker.image('python:3.9-slim').inside {
        stage('Build') {
            checkout scm
            sh 'pip install --no-cache-dir --target=/tmp/pip-packages pytest pyinstaller'
            sh 'PYTHONPATH=/tmp/pip-packages python3 -m py_compile sources/add2vals.py sources/calc.py'
        }

        stage('Test') {
            try {
                sh 'PYTHONPATH=/tmp/pip-packages python3 -m pytest --verbose --junit-xml test-reports/results.xml sources/test_calc.py'
            } finally {
                junit 'test-reports/results.xml'
            }
        }

        stage('Deliver') {
            if (currentBuild.result in ['UNSTABLE', 'FAILURE']) {
                error "Skipping deliver, build is ${currentBuild.result}"
            }
            sh 'PYTHONPATH=/tmp/pip-packages python3 -m PyInstaller --onefile sources/add2vals.py'
            archiveArtifacts 'dist/add2vals'
        }
    }
}