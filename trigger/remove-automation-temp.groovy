class ScriptExecutor {
    public static void main(String[] args) {
        
		def parameterFilePath = args[0];
		def parameterFile = new File(parameterFilePath);
        if(parameterFile.exists() && !parameterFile.isDirectory()) { 
            parameterFile.eachLine {  
				def tempDir = new File(it);
				if(tempDir.exists() && tempDir.isDirectory()) 
				{
					tempDir.deleteDir();
					println "$it has been deleted"
				}
            }
        }
    }
}
