
class ScriptExecutor {
    
    public static void main(String[] args) {
        
        def runner = new UnitTestRunner(args[0]);
		runner.run();
    }
}


class UnitTestRunner{
	def rootPath;
	def nunitConsoleLocation;
	
    public UnitTestRunner(def rootPath){
        this.rootPath = rootPath;
		this.nunitConsoleLocation = "D:\\Jenkins\\tools\\NUnit-3.0.1\\bin\\nunit3-console.exe";
    }
	
	public debug(){
		def parameters = getParameters();
		def command = nunitConsoleLocation + " " + parameters +" /result:\"" + rootPath + "\\UnitTest.xml;format=nunit2\"";
		println command;
	}
	
	
	public run(){
		def parameters = getParameters();
		def command = nunitConsoleLocation + " " + parameters +" /result:\"" + rootPath + "\\UnitTest.xml;format=nunit2\"";
		runCommand(command);
	}
		
	private getParameters(){
		def list=[];
		def files = "";
		def root = new File(rootPath);
		getUnitTestFiles(root, list);
		
		list.each { 
			files += "\"" + it + "\" ";
		};
		
		return files;		
	}
	
	private getUnitTestFiles(def file, def list){
		if (file.isDirectory()) {
			for (def c : file.listFiles()){				
				getUnitTestFiles(c, list);
			}				
		}
		
		def matched = file.name.endsWith("Tests.dll") && !file.path.contains("\\obj\\");
		if(matched){
			list << file.path;	
		} 				
	}
	
	private runCommand(def command){
		println("Now is: " + (new Date())+". Start to execute: "+ command);
		println command.execute().text;
		println("Now is: " + (new Date())+". Finished to execute");
	}	
}
