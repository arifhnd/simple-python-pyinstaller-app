node {
    docker.image('python:3.9-slim').inside {
        stage('Build') {
            checkout scm
            sh 'python3 -m py_compile sources/add2vals.py sources/calc.py'
        }
    }

    stage('Test') {
        // Logika skipStagesAfterUnstable: Cek status sebelum lanjut
        if (currentBuild.result == 'UNSTABLE') {
            echo "Skipping Test stage because build is UNSTABLE"
        } else {
            try {
                sh 'py.test --verbose --junit-xml test-reports/results.xml sources/test_calc.py'
            } finally {
                // Pengganti post { always { ... } }
                junit 'test-reports/results.xml'
            }
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