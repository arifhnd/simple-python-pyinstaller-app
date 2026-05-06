node {
    def ciImage

    // Build custom CI image dari Dockerfile
    // docker.build hanya rebuild kalau Dockerfile berubah
    stage('Checkout') {
        // Tarik kode dari Git ke workspace
        checkout scm 
    }

    stage('Build Image') {
        // Sekarang file Dockerfile sudah ada di workspace
        ciImage = docker.build(
            'python-ci:latest',
            '-f Dockerfile .'
        )
    }

    ciImage.inside {
        stage('Build') {
            checkout scm

            sh 'python3 -m py_compile sources/add2vals.py sources/calc.py'
            echo 'Syntax check passed.'
        }

        stage('Test') {
            try {
                sh '''
                    python3 -m pytest \
                        --verbose \
                        --junit-xml test-reports/results.xml \
                        sources/test_calc.py
                '''
            } finally {
                // Selalu publish hasil test meskipun ada yang gagal
                junit 'test-reports/results.xml'
            }
        }

        stage('Deliver') {
            // Skip deliver kalau test gagal atau unstable
            if (currentBuild.result in ['UNSTABLE', 'FAILURE']) {
                error "Skipping deliver — build status: ${currentBuild.result}"
            }

            sh 'pyinstaller --onefile sources/add2vals.py'

            // Archive binary hasil build
            archiveArtifacts artifacts: 'dist/add2vals', fingerprint: true
            echo 'Artifact archived: dist/add2vals'
        }
    }
}