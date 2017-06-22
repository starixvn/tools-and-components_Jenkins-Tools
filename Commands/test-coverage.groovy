
class ScriptExecutor {
    
    public static void main(String[] args) {
        String excludeFilter = "";
		
		if(args.size() > 1){
			excludeFilter = args[1];
		}
		
        def runner = new TestCoverageRunner(args[0],excludeFilter);
		runner.run();
    }
}


class TestCoverageRunner{
	def rootPath;
	def nunitConsoleLocation;
	def openCoverLocation;
	def reportGeneratorLocation;
	def openCoverToCoberturaConverterLocaltion;
	def excludeFilter;
	
    public TestCoverageRunner(def rootPath, def excludeFilter){
        this.rootPath = rootPath;		
		this.nunitConsoleLocation = "D:\\Jenkins\\tools\\NUnit.ConsoleRunner.3.2.1\\tools\\nunit3-console.exe";		
		this.openCoverLocation = "D:\\Jenkins\\tools\\opencover.4.6.519\\OpenCover.Console.exe";
		this.reportGeneratorLocation="D:\\Jenkins\\tools\\ReportGenerator\\ReportGenerator.exe";
		this.openCoverToCoberturaConverterLocaltion="D:\\Jenkins\\tools\\OpenCover\\OpenCoverToCoberturaConverter.exe";
		
		this.excludeFilter = "";
		
		if (excludeFilter?.trim()) {
			String[] parts = excludeFilter.split(';');
			
			for( String filter : parts ){
				this.excludeFilter += " -[" + filter + "]*";
				this.excludeFilter += " -[" + filter + ".*]*";
			}
		}
    }
	
	public getOpenCoverCommand(){
		def files = getParameters();
		def openCoverCommand = openCoverLocation +
			" -register:user " +
			"-target:"  +
			nunitConsoleLocation +
			" -targetargs:\"" +
			files +
			"\" -filter:\"+[*]*" + 
			excludeFilter + "\" " +
			"-output:\"" +
			rootPath +
			"\\coverage.xml\"";
		return openCoverCommand;
	}
	
	public getReportCommand(){
		def reportCommand = reportGeneratorLocation +
			" -reports:\"" +
			rootPath +
			"\\coverage.xml\" -targetdir:\"" +
			rootPath +
			"\\cireport\\testcoveragereport\"";
		return reportCommand;
	}
	
	public getCoberturaConverterCommand(){
	
		def coberturaConverterCommand = openCoverToCoberturaConverterLocaltion +
			" \"-input:" +
			rootPath +
			"\\coverage.xml\"" +
			" \"-output:" +
			rootPath +
			"\\cobertura.xml\" \"-sources:" +
			rootPath +
			"\"";
		return coberturaConverterCommand;
	}
		
	public run(){
		def openCoverCommand = getOpenCoverCommand();
		def reportCommand = getReportCommand();
		def coberturaCommand = getCoberturaConverterCommand();
		
		println openCoverCommand;
		println reportCommand;
		println coberturaCommand;
	
		runCommand(openCoverCommand);
		runCommand(reportCommand);
		runCommand(coberturaCommand);
	}
	
	public debug(){
		def openCoverCommand = getOpenCoverCommand();
		def reportCommand = getReportCommand();
		def coberturaCommand = getCoberturaConverterCommand();
		
		println openCoverCommand;
		println reportCommand;
		println coberturaCommand;		
	}
	
	private getParameters(){
		def list=[];
		def files = "";
		def root = new File(rootPath);
		getUnitTestFiles(root, list);
		
		list.each { 
			files += "\"\"" + it + "\"\" ";
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
		def potential = file.name.endsWith("Tests.dll") && (parentDir == "debug" || parentDir =="Debug") && !file.path.contains("\\obj\\");
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
