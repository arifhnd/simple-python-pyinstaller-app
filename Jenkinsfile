node {
    docker.image('python:3.9-slim').inside {
        stage('Build') {
            checkout scm
            sh 'python3 -m py_compile sources/add2vals.py sources/calc.py'
        }
    }

    stage('Test') {
        sh 'pip3 install pytest'
        
        try {
            sh 'python3 -m pytest --verbose --junit-xml test-reports/results.xml sources/test_calc.py'
        } finally {
            junit 'test-reports/results.xml'
        }
    }

    stage('Deliver') {
        // Cek lagi status sebelum tahap delivery
        if (currentBuild.result == 'UNSTABLE' || currentBuild.result == 'FAILURE') {
            echo "Skipping Deliver stage due to build status: ${currentBuild.result}"
        } else {
            sh 'pyinstaller --onefile sources/add2vals.py'
            
            // Pengganti post { success { ... } }
            if (currentBuild.result == null || currentBuild.result == 'SUCCESS') {
                archiveArtifacts 'dist/add2vals'
            }
        }
    }
}