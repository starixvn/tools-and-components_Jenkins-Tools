
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
		this.nunitConsoleLocation = "D:\\Jenkins\\tools\\NUnit\\nunit3-console.exe";
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
		
		def parentDir = file.getParentFile().name;
		def path = file.getPath();
		def name = file.getName();
		def potential = name.endsWith("Tests.dll") && !path.contains("\\obj\\");
		if(potential) {
			def nameWithoutExtention = file.name.lastIndexOf('.').with {it != -1 ? file.name[0..<it] : file.name};		
			def projectName = file.getParentFile().getParentFile().getParentFile().getName();
		
			if(nameWithoutExtention == projectName){
				list << file.getPath();	
			} 				
		}
	}
	
	private runCommand(def command){
		println("Now is: " + (new Date())+". Start to execute: "+ command);
		println command.execute().text;
		println("Now is: " + (new Date())+". Finished to execute");
	}	
}
