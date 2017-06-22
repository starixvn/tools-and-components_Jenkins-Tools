// function isRightTime: check if now is right time for deployment. Ex: between 20h and 7h
class ScriptExecutor {
    def static triggerFilePath = System.getenv("WORKSPACE") + "\\deploy.trigger";
    def static deployedCommitFilePath =  System.getenv("WORKSPACE") + "\\last-commit.deploy";
    def static currentGitCommit =  System.getenv("GIT_COMMIT");

    public static void main(String[] args) {
        
        // Declare object
        def deploymentTrigger = new DeploymentTrigger(triggerFilePath);
        def conditionalDeploymentTrigger = new ConditionalDeploymentTrigger(deployedCommitFilePath, currentGitCommit);

        // Show current time
        println("Now is: " + (new Date()));

        // Check if the deployment is forced by user
        def deployIsForced = args.length > 0;
        def shouldDeploy = conditionalDeploymentTrigger.shouldDeploy();

		println "Commit: ${currentGitCommit}. deployIsForced: ${deployIsForced}, shouldDeploy: ${shouldDeploy}"

        if(shouldDeploy || deployIsForced){
            deploymentTrigger.trigger();
        }
        else{
            deploymentTrigger.removeTrigger();
        }
    }
}

class ConditionalDeploymentTrigger{
    def deployedCommitFilePath;
    def commitHash;

    public ConditionalDeploymentTrigger(def deployedCommitFilePath, def commitHash){
        this.deployedCommitFilePath = deployedCommitFilePath;
        this.commitHash = commitHash;
    }

    public isRightTime(){
        def rightNow = Calendar.getInstance();
        def currentHours = rightNow.get(Calendar.HOUR_OF_DAY);

        def rightTime = currentHours <= 7 || currentHours >= 20;

        return rightTime;
    }

    public isCommitDeployed(){    
        def currentGitCommitIsDeployed = false;
        def deployedCommitFile = new File(deployedCommitFilePath);
        if(deployedCommitFile.exists() && !deployedCommitFile.isDirectory()) { 
            deployedCommitFile.eachLine {    
                if(it == commitHash){
                    currentGitCommitIsDeployed = true;
                }
            }
        }

		println "Commit " + commitHash + " has been deployed: " + (currentGitCommitIsDeployed ? "true" : "false");
        return currentGitCommitIsDeployed;
    }

    public shouldDeploy(){
        return isRightTime() && !isCommitDeployed();
    }
}

class DeploymentTrigger{
    def triggerFilePath;

    public DeploymentTrigger(def triggerFilePath){
        this.triggerFilePath = triggerFilePath;
    }

    public trigger(){
        def out = new PrintWriter(new BufferedWriter(new FileWriter(triggerFilePath, false)));
        out.println("Trigger");
        out.close();
    }

    public removeTrigger(){
       def triggerFile = new File(triggerFilePath);
        if(triggerFile.exists() && !triggerFile.isDirectory()) { 
           triggerFile.delete();
        }
    }
}