class ScriptExecutor {
    public static void main(String[] args) {
		def deployedCommitFilePath =  System.getenv("WORKSPACE") + "\\last-commit.deploy";
		def currentGitCommit =  System.getenv("GIT_COMMIT");        
		 
        def out = new PrintWriter(new BufferedWriter(new FileWriter(deployedCommitFilePath, true)));
        out.println(currentGitCommit);
		out.close();
		println "Commit " + currentGitCommit + " has been deployed"
    }
}
