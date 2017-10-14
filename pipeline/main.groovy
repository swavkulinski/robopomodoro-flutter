timeout(60) {
    timestamps {
            node {
                checkout scm
                
                stage('Flutter upgrade') {
                    sh "flutter upgrade"
                }

                stage('Flutter Doctor') {
                    sh "flutter doctor > doctor_report.log"
                    archiveArtifacts artifacts: 'doctor_report.log', fingerprint: true
                }

                stage('Flutter analyze') {
                    sh "flutter analyze > analyze_report.log"
                    archiveArtifacts artifacts: 'analyze_report.log', fingerprint: true
                }

                stage('Debug build type : Test Coverage') {
                    sh "flutter test > tests.log"
                    archiveArtifacts artifacts: 'tests.log', fingerprint: true
                }

                if ("${env.BRANCH_NAME}".toString() != "develop") {
                    return
                }
                stage('Build Android') {
                    sh "flutter build apk"
                    archiveArtifacts artifacts: 'app/build/outputs/apk/*.apk', fingerprint: true
                }

                stage('Archive iOS') {
                    sh "flutter build ios"
                    //TODO archive artifacts

                }

        }
    }
}