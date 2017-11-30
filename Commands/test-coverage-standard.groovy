
class ScriptExecutor {
    
    public static void main(String[] args) {
        
        def runner = new TestCoverageRunner(args[0]);
		runner.run();
    }
}


class TestCoverageRunner{
	def rootPath;
	def nunitConsoleLocation;
	def openCoverLocation;
	def reportGeneratorLocation;
	def openCoverToCoberturaConverterLocaltion;
	
    public TestCoverageRunner(def rootPath){
        this.rootPath = rootPath;
		this.nunitConsoleLocation = "D:\\Jenkins\\tools\\NUnit\\nunit3-console.exe";		
		this.openCoverLocation = "D:\\Jenkins\\tools\\opencover\\OpenCover.Console.exe";
		this.reportGeneratorLocation="D:\\Jenkins\\tools\\ReportGenerator\\ReportGenerator.exe";
		this.openCoverToCoberturaConverterLocaltion="D:\\Jenkins\\tools\\OpenCover\\OpenCoverToCoberturaConverter.exe";
    }
	
	public getOpenCoverCommand(){
		def files = getParameters();
		def openCoverCommand = openCoverLocation +
			" -register:user " +
			"-target:"  +
			nunitConsoleLocation +
			" -targetargs:\"" +
			files +
			" /result:\"\"" + rootPath + "\\UnitTest.xml;format=nunit2\"\" \" -filter:+[*]* -output:\"" +
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
