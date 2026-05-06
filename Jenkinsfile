node {
    docker.image('python:3.9-slim').inside {
        stage('Build') {
            checkout scm
            sh 'pip install --no-cache-dir pytest pyinstaller'
            sh 'python3 -m py_compile sources/add2vals.py sources/calc.py'
        }

        stage('Test') {
            try {
                sh 'python3 -m pytest --verbose --junit-xml test-reports/results.xml sources/test_calc.py'
            } finally {
                junit 'test-reports/results.xml'
            }
        }

        stage('Deliver') {
            if (currentBuild.result == 'UNSTABLE' || currentBuild.result == 'FAILURE') {
                echo "Skipping Deliver stage due to build status: ${currentBuild.result}"
            } else {
                sh 'pyinstaller --onefile sources/add2vals.py'
                archiveArtifacts 'dist/add2vals'
            }
        }
    }
}