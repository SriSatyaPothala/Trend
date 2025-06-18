pipeline{
    agent any
    environment{
        // Docker Hub repository 
        DOCKER_HUB_REPO = "srisatyap/dev"
        GIT_REPO_NAME = "Trend"
    }
    stages{
        stage('Check for [skip ci]'){
            steps{
                script {
                    def commitMessage = sh(script: "git log -1 --pretty=%B", returnStdout: true).trim()
                    if (commitMessage.contains('[skip ci]')){
                        echo 'Detected [skip ci] in commitMessage. so skipping Build'
                        currentBuild.result = 'SUCCESS'
                        error('Exiting due to [skip ci]')
                    }
                }
            }
        }
        stage('Build Docker Image and push to docker hub'){
            steps{
                script {
                    withCredentials([usernamePassword(credentialsId: 'docker-hub-cred', usernameVariable: 'DOCKER_USERNAME', passwordVariable: 'DOCKER_PASSWORD')]){
                        // define buildtag with the latest build number 
                        def buildtag = "${env.BUILD_NUMBER}"
                        // build the docker image
                        echo "building docker image..."
                        sh "docker build -t ${env.DOCKER_HUB_REPO}:${buildtag} . "
                        //login to dockerhub using above credentials
                        sh "echo ${DOCKER_PASSWORD} | docker login -u ${DOCKER_USERNAME} --password-stdin"
                        echo "pushing docker image to dockerhub" 
                        sh "docker push ${env.DOCKER_HUB_REPO}:${buildtag}" 
                    }
                }
            }
        }
        // git version > 2.35.2 allows modifications from the same user as the git repo owner.
        //stage('Fix git ownership'){
            //steps{
                //sh '''
                //git config --global --add safe.directory /var/lib/jenkins/workspace/springbootapp-pipeline
                //if [-d ".git"]; then
                 // chown -R root:root .git
                //fi
                //'''
            //}
        //}
        stage('Update Image tag in Remote repository'){
            steps{
                withCredentials([usernamePassword(credentialsId: 'github-cred', usernameVariable:'GIT_USER', passwordVariable: 'GIT_TOKEN')]){
                    sh """
                     pwd
                     echo "configuring git user details for commit history...."
                     git checkout main
                     git pull https://${GIT_TOKEN}@github.com/${GIT_USER}/${env.GIT_REPO_NAME} main --rebase
                     git config user.email "srisatyapothala11@gmail.com"
                     git config user.name "SriSatyaPothala"
                     BUILD_NUMBER=${BUILD_NUMBER}
                     echo "updating manifest with latest image tag..."
                     sed -i "s|image: srisatyap/dev:.*|image: srisatyap/dev:${BUILD_NUMBER}|g" manifests/deployment.yml
                     echo "commiting the changes to the remote repo..."
                     git add manifests/deployment.yml
                     git commit -m "Modified deployment manifest with the latest build number [skip ci]" || echo "No changes to commit"
                     echo "Pushing the changes to the repo..."
                     git push https://${GIT_TOKEN}@github.com/${GIT_USER}/${env.GIT_REPO_NAME} HEAD:main   
                    """
                }

            }
        }
        stage('Deploy the application using AWS EKS'){
            steps{
                sh ''' 
                echo 'configuring kubectl for EKS...'
                aws eks update-kubeconfig --region ap-south-1 --name miniproject2
                echo 'deploying application in EKS....'
                kubectl apply -f deployment.yml 
                kubectl apply -f service.yml 
                '''
            }
        }
    }
}