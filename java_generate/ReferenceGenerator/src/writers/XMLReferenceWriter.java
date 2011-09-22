package writers;

import java.io.File;
import java.io.IOException;
import java.util.ArrayList;
import java.util.HashMap;

import javax.xml.parsers.DocumentBuilder;
import javax.xml.parsers.DocumentBuilderFactory;
import javax.xml.parsers.ParserConfigurationException;
import javax.xml.xpath.XPath;
import javax.xml.xpath.XPathConstants;
import javax.xml.xpath.XPathExpression;
import javax.xml.xpath.XPathExpressionException;
import javax.xml.xpath.XPathFactory;

import org.w3c.dom.Document;
import org.w3c.dom.NodeList;
import org.xml.sax.SAXException;

public class XMLReferenceWriter extends BaseWriter {
	
	public static void write(String sourceDir, IndexWriter indexWriter) throws IOException
	{
		write(sourceDir, "", indexWriter);
	}
	
	public static void write(String sourceDir, String dstDir, IndexWriter indexWriter) throws IOException
	{
		File directory = new File(sourceDir);
		File[] files = directory.listFiles();
		
		if(files == null ){
			return;
		}
		
		for(File f : files )
		{
			if(f.getAbsolutePath().endsWith(".xml"))
			{
				parseFile(f, dstDir, indexWriter);
			}
		}
	}
	
	public static void parseFile(File f, String dst, IndexWriter indexWriter)
	{
		DocumentBuilderFactory factory = DocumentBuilderFactory.newInstance();
		factory.setNamespaceAware(true);
		DocumentBuilder builder;
		Document doc = null;
		try {
			builder = factory.newDocumentBuilder();
			doc = builder.parse(f.getPath());
		} catch (ParserConfigurationException e) {
			// TODO Auto-generated catch block
			System.out.println("Failed to parse " + f.getAbsolutePath());
		} catch (SAXException e) {
			// TODO Auto-generated catch block
			System.out.println("Failed to parse " + f.getAbsolutePath());
		} catch (IOException e) {
			// TODO Auto-generated catch block
			System.out.println("Failed to parse " + f.getAbsolutePath());
		}
		
		TemplateWriter templateWriter = new TemplateWriter();
        XPathFactory xpathFactory = XPathFactory.newInstance();
        XPath xpath = xpathFactory.newXPath();
		try {			
			HashMap<String, String> vars = new HashMap<String, String>();
			
			String category = (String) xpath.evaluate("//category", doc, XPathConstants.STRING);
			String subcategory = (String) xpath.evaluate("//subcategory", doc, XPathConstants.STRING);
			String name = (String) xpath.evaluate("//name", doc, XPathConstants.STRING);
			String description = (String) xpath.evaluate("//description", doc, XPathConstants.STRING);
			String syntax = (String) xpath.evaluate("//syntax", doc, XPathConstants.STRING);
			String classname = (String) xpath.evaluate("//classname", doc, XPathConstants.STRING);
			String classAnchor = "";
			
			if( subcategory.equals("Method") )
			{
				classname = category;
				classAnchor = getAnchorFromName( classname );
			}
			
			String constructors = getConstructors( xpath, doc );
			
			// get anchor from original filename
			String path = f.getAbsolutePath();
			String anchorBase = path.substring( path.lastIndexOf("/")+1, path.indexOf(".xml"));
			if( name.endsWith("()") )
			{
				if( !anchorBase.endsWith("_" ) )
				{
					anchorBase += "_";
				}
			}
			String anchor = anchorBase + ".html";
			String usage = (String) xpath.evaluate("//usage", doc, XPathConstants.STRING);
			if(indexWriter instanceof LibraryIndexWriter ){				
				((LibraryIndexWriter) indexWriter).addEvent(name, anchor);
				vars.put("csspath", "../../");
			} else {				
				indexWriter.addItem(category, subcategory, name, anchor);
			}
			
			vars.put("examples", getExamples(doc));
			vars.put("name", name);
			vars.put("description", description);
			vars.put("syntax", syntax);
			vars.put("usage", usage);
			vars.put("parameters", getParameters(doc, "" ));
			vars.put("related", getRelated(doc));
			vars.put( "constructors", constructors );
			vars.put( "classname", classname );
			vars.put( "classanchor", classAnchor );
			
			vars.put( "category",  category );
			vars.put( "subcategory", subcategory );
			
			if( constructors != "" )
			{	// we are documenting a class
				vars.put("classname", name);
				// TODO: pull in methods and other things
				ArrayList< HashMap<String, String> > methodSet = getPropertyInfo( doc, xpath, "method", anchorBase + "_" );
				ArrayList< HashMap<String, String> > fieldSet = getPropertyInfo( doc, xpath, "field", anchorBase + "_" );
				
				vars.put( "methods", templateWriter.writeLoop("Property.partial.html", methodSet) );
				vars.put( "fields", templateWriter.writeLoop("Property.partial.html", fieldSet) );
				
				if( vars.get("parameters") == "" )
				{	// get constructor parameters
					vars.put("parameters", getParameters(doc, "c" ));
				}
				templateWriter.write("Class.template.html", vars, dst + anchor);
			}
			else
			{
				templateWriter.write("Generic.template.html", vars, dst + anchor);
			}
			
		} catch (XPathExpressionException e) {
			// TODO Auto-generated catch block
			System.out.println("Failed to parse " + f.getAbsolutePath());
		} catch (IOException e) {
			// TODO Auto-generated catch block
			System.out.println("Failed to parse " + f.getAbsolutePath());
		}
	}
	
	private static String getConstructors( XPath xpath, Document doc)
	{
		String constructors = "";
		try {
			constructors = (String) xpath.evaluate("//constructor", doc, XPathConstants.STRING );
		} catch (XPathExpressionException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		return constructors;
	}
	
	protected static ArrayList< HashMap<String, String > > getPropertyInfo( Document doc, XPath xpath, String tag, String anchorBase ) 
	{
		ArrayList<HashMap<String, String>> ret = new ArrayList< HashMap<String, String> >();
		try 
		{
			String prefix = tag.substring(0, 1);
			XPathExpression expr = xpath.compile("//" + tag);
			Object result = expr.evaluate( doc, XPathConstants.NODESET);
			NodeList properties = (NodeList) result;

			for (int i = 0; i < properties.getLength(); i++ )
			{
				HashMap<String, String> property = new HashMap<String, String>();
				
				expr = xpath.compile( prefix + "name" );
				String name = (String) expr.evaluate( properties.item(i), XPathConstants.STRING );
				String anchor = anchorBase + getAnchorFromName( name );
				String description = (String) xpath.evaluate( prefix + "description", properties.item(i), XPathConstants.STRING );
				
				property.put("name", name );
				property.put("anchor", anchor );
				property.put("desc", description );
			
				ret.add( property );
			}
		} catch (XPathExpressionException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		return ret;
	}
	
	protected static String getParameters(Document doc, String tagPrefix) throws IOException{
		
		ArrayList<HashMap<String, String>> ret = new ArrayList<HashMap<String,String>>();
		//get parameters for this methos
		XPath xpath = getXPath();
		try{
			XPathExpression expr = xpath.compile("//" + tagPrefix + "parameter");
			Object result = expr.evaluate(doc, XPathConstants.NODESET);
			NodeList parameters = (NodeList) result;

			for (int i = 0; i < parameters.getLength(); i++) { 
				String name = (String) xpath.evaluate( tagPrefix + "label", parameters.item(i), XPathConstants.STRING);
				String desc = (String) xpath.evaluate( tagPrefix + "description", parameters.item(i), XPathConstants.STRING);

				HashMap<String, String> map = new HashMap<String, String>();
				map.put("name", name);
				map.put("description", desc);
				ret.add(map);						

			}
		} catch (XPathExpressionException e) {
			// TODO: handle exception
		}
		
		TemplateWriter templateWriter = new TemplateWriter();
		//write out all parameters with a short loop
		return templateWriter.writeLoop("Parameter.partial.html", ret);
	}
	
	protected static String getRelated(Document doc) throws IOException{
		TemplateWriter templateWriter = new TemplateWriter();
		ArrayList<HashMap<String, String>> vars = new ArrayList<HashMap<String,String>>();
		
		try{
			XPath xpath = getXPath();
			String relatedS = (String) xpath.evaluate("//related", doc, XPathConstants.STRING);
			if(relatedS.equals("")){
				return "";
			}
			String[] related = relatedS.split("\\n");
			
			for(int i=0; i < related.length; i++ ){
				HashMap<String, String> map = new HashMap<String, String>();
				String name = related[i];
				if(!name.equals("")){
					map.put("name", name);
					map.put("anchor", getAnchorFromName(name));				
					vars.add(map);					
				}
			}
		}catch(XPathExpressionException e){
			
		}
		return templateWriter.writeLoop("Related.partial.html", vars);
	}
	
	static protected XPath getXPath(){
		XPathFactory xpathFactory = XPathFactory.newInstance();
		return xpathFactory.newXPath();
	}
}
