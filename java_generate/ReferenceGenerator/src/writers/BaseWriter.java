package writers;

import java.io.BufferedWriter;
import java.io.File;
import java.io.FileWriter;
import java.io.IOException;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.HashMap;
import java.util.Locale;
import java.util.TimeZone;

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

import com.sun.javadoc.ClassDoc;
import com.sun.javadoc.ConstructorDoc;
import com.sun.javadoc.Doc;
import com.sun.javadoc.ExecutableMemberDoc;
import com.sun.javadoc.FieldDoc;
import com.sun.javadoc.MethodDoc;
import com.sun.javadoc.ParamTag;
import com.sun.javadoc.Parameter;
import com.sun.javadoc.ProgramElementDoc;
import com.sun.javadoc.SeeTag;
import com.sun.javadoc.Tag;

public class BaseWriter {
	// Some utilities

	public final static String MODE_JAVASCRIPT = "js";

	public BaseWriter()
	{

	}

	protected static boolean needsWriting(ProgramElementDoc doc){
		if( Shared.i().isWebref(doc) )
		{
			return hasXMLDocument( doc );
		}
		return false;
	}

	protected static BufferedWriter makeWriter(String anchor) throws IOException
	{
		return makeWriter(anchor, false);
	}

	protected static String getWriterPath( String anchor, Boolean isLocal )
	{
		if (!isLocal) {
			return Shared.i().getOutputDirectory() + "/" + anchor;
		} else
		{
			return Shared.i().getLocalOutputDirectory() + anchor;
		}
	}

	protected static BufferedWriter makeWriter(String anchor, Boolean isLocal) throws IOException {
		FileWriter fw = new FileWriter( getWriterPath( anchor, isLocal ) );

		return new BufferedWriter(fw);
	}

	protected static String getAnchor(ProgramElementDoc doc)
	{
		String ret = getAnchorFromName(getName(doc));

		if(doc.containingClass() != null && !Shared.i().isRootLevel(doc.containingClass()))
		{
			ret = doc.containingClass().name() + "_" + ret;
		}

		if(!Shared.i().isCore(doc)){
			//add package name to anchor
			String[] parts = doc.containingPackage().name().split("\\.");
			String pkg = parts[parts.length-1] + "/";
			ret = "libraries/" + pkg + ret;
		}

		return ret;
	}

	protected static String getLocalAnchor(ProgramElementDoc doc)
	{
		String ret = getAnchorFromName(getName(doc));
		if(doc.containingClass() != null){
			ret = doc.containingClass().name() + "_" + ret;
		}

		return ret;
	}

	protected static String getReturnTypes(MethodDoc doc)
	{
		String ret = nameInPDE(doc.returnType().toString());
		if(doc.containingClass() != null)
		{
			for(MethodDoc m : doc.containingClass().methods())
			{
				if( m.name().equals(doc.name()) && m.returnType() != doc.returnType() )
				{
					String name = getSimplifiedType( nameInPDE(m.returnType().toString()) );
					if( ! ret.contains( name ) )
					{ // add return type name if it's not already included
						ret += ", " + name;
					}
				}
			}
		}

		// add "or" (split first to make sure we don't mess up the written description)
		ret = ret.replaceFirst( ",([^,]+)$", ", or$1" );
		if( ! ret.matches(".+,.+,.+") )
		{
			ret = ret.replace( ",", "" );
		}

		return ret;
	}

	protected static String getSimplifiedType( String str )
	{
		if( str.equals("long") ){ return "int"; }
		if( str.equals("double") ){ return "float"; }

		return str;
	}

	protected static String getName(Doc doc) { // handle
		String ret = doc.name();
		if(doc instanceof MethodDoc)
		{
			ret = ret.concat("()");
		} else if (doc.isField()){
			// add [] if needed
			FieldDoc d = (FieldDoc) doc;
			ret = ret.concat(d.type().dimension());
		}
		return ret;
	}

	protected static String getAnchorFromName(String name){
		// change functionName() to functionName_
		if( name.endsWith("()") ){
			name = name.replace("()", "_");
		}
		// change "(some thing)" to something
		if( name.contains("(") && name.contains(")") ){
			int start = name.lastIndexOf("(") + 1;
			int end = name.lastIndexOf(")");
			name = name.substring(start, end);
			name = name.replace(" ", "");
		}
		// change thing[] to thing
		if( name.contains("[]")){
			name = name.replaceAll("\\[\\]", "");
		}
		// change "some thing" to "some_thing.html"
		name = name.replace(" ", "_").concat(".html");
		return name;
	}

	static protected String getBasicDescriptionFromSource(ProgramElementDoc doc) {
		return getBasicDescriptionFromSource(longestText(doc));
	}

	static protected String getBriefDescriptionFromSource(ProgramElementDoc doc) {
		Tag[] sta = doc.tags("brief");
		if(sta.length > 0){
			return sta[0].text();
		}
		return getBasicDescriptionFromSource(doc);
	}

	static protected String longestText(ProgramElementDoc doc){
		if(Shared.i().isWebref(doc)){
			//override longest rule if the element has an @webref tag
			return doc.commentText();
		}

		String s = doc.commentText();
		if( doc.isMethod() ){
			for(ProgramElementDoc d : doc.containingClass().methods()){
				if(d.name().equals(doc.name() ) ){
					if(d.commentText().length() > s.length()){
						s = d.commentText();
					}
				}
			}
		} else if(doc.isField()){
			for(ProgramElementDoc d : doc.containingClass().fields()){
				if(d.name().equals(doc.name() ) ){
					if(d.commentText().length() > s.length()){
						s = d.commentText();
					}
				}
			}
		}
		return s;
	}

	static protected String getBasicDescriptionFromSource(String s){
		String[] sa = s.split("(?i)(<h\\d>Advanced:?</h\\d>)|(=advanced)");
		if (sa.length != 0)
			s = sa[0];
		return s;
	}

	static protected String getAdvancedDescriptionFromSource(ProgramElementDoc doc) {
		return getAdvancedDescriptionFromString(longestText(doc));
	}
	static private String getAdvancedDescriptionFromString(String s) {
		String[] sa = s.split("(?i)(<h\\d>Advanced:?</h\\d>)|(=advanced)");
		if (sa.length > 1)
			s = sa[1];
		return s;
	}



	//

	protected static String getXMLPath(ProgramElementDoc doc) {
		String path = Shared.i().getXMLDirectory();
		String name = doc.name();
		String suffix = ".xml";
		if(doc.containingClass() != null){
			if(Shared.i().isRootLevel(doc.containingClass())){
				//inside PApplet or other root-level class
				if(doc instanceof FieldDoc){
					//if there is a method of the same name, append _var
					for( Doc d : doc.containingClass().methods()){
						if(d.name().equals(doc.name())){
							suffix = "_var" + suffix;
							break;	//don't append multiple times
						}
					}
				}
			} else {
				name = doc.containingClass().name() + "_" + name;
			}
		}

		if( !Shared.i().isCore(doc)){
			//if documentation is for a library element
			String[] pkg = doc.containingPackage().name().split("\\.");
			path = path + "LIB_" + pkg[pkg.length-1] + "/";
		}


		return path + name + suffix;
	}

	static protected String getExamples(ProgramElementDoc doc) throws IOException{
		return getExamples(getXMLPath(doc));
	}

	static private Document getXMLDocument(String path) throws IOException {
		DocumentBuilderFactory factory = DocumentBuilderFactory.newInstance();
		factory.setNamespaceAware(true);
		DocumentBuilder builder = null;
		Document doc = null;
		try {
			builder = factory.newDocumentBuilder();
		} catch (ParserConfigurationException e) {
			System.out.println( "Failed to load XML: " + e.getMessage());
		}

		if( builder != null )
		{
			try {
				doc = builder.parse(path);
			} catch (SAXException e) {
				System.out.println( "Failed to parse XML: " + e.getMessage() );
			} catch (IOException e) {
				System.out.println( "Failed to parse XML: " + e.getMessage() );
			}
		}


		return doc;
	}

	private static boolean hasXMLDocument( ProgramElementDoc doc )
	{
		String path = getXMLPath( doc );
		File f = new File( path );
		if( f.exists() )
		{
			return true;
		}
		return false;
	}

	static protected String getExamples(String path) throws IOException {
		Document doc = getXMLDocument(path);
		if( doc != null )
			return getExamples(doc);
		else
		{
			System.out.println("Unable to get examples from " + path + "; returning an empty string.");
			return "";
		}
	}

	protected static String getExamples(Document doc) throws IOException{
		//Parse the examples from an XML document
		TemplateWriter templateWriter = new TemplateWriter();
		ArrayList<HashMap<String, String>> exampleList = new ArrayList<HashMap<String, String>>();
		XPathFactory xpathFactory = XPathFactory.newInstance();
		XPath xpath = xpathFactory.newXPath();
		try {
			XPathExpression expr = xpath.compile("//example");
			Object result = expr.evaluate(doc, XPathConstants.NODESET);
			NodeList examples = (NodeList) result;

			for (int i = 0; i < examples.getLength(); i++) {
				HashMap<String, String> example = new HashMap<String, String>();

				expr = xpath.compile("image");
				String img = (String) expr.evaluate(examples.item(i),
						XPathConstants.STRING);
				expr = xpath.compile("code");
				String code = (String) expr.evaluate(examples.item(i),
						XPathConstants.STRING);

				example.put("image", Shared.i().getImageDirectory()
						+ img);
				if(img.equals(""))
				{	// if no image, replace with empty string
					example.put("image", "");
				}
				example.put("code", code);

				exampleList.add(example);
			}

		} catch (XPathExpressionException e) {
			e.printStackTrace();
		}

		String exampleInner = templateWriter.writeLoop("/example.partial.html", exampleList);
		HashMap<String, String> map = new HashMap<String, String>();
		map.put("examples", exampleInner);
		return templateWriter.writePartial("examples.partial.html", map);
	}

	protected static String getXMLDescription(ProgramElementDoc doc) throws IOException {
		Document xmlDoc = getXMLDocument(getXMLPath(doc));
		if( xmlDoc != null )
			return getXMLDescription(xmlDoc);
		else {
			System.out.println("Unable to get description from " + getXMLPath(doc) + "; returning an empty string.");
			return "";
		}
	}

	/**
	 *	Based upon Shared.addDescriptionTag().
	 *
	 *	Hint: this loads and adds js_mode/description as well
	 */
	protected static String getXMLDescription(Document doc)
	{
		XPathFactory xpathFactory = XPathFactory.newInstance();
		XPath xpath = xpathFactory.newXPath();

		TemplateWriter templateWriter = new TemplateWriter();

		String desc = "";

		for( String component : Shared.i().getDescriptionSets() )
		{
			try
			{
				XPathExpression expr = xpath.compile(component);
				String result = (String) expr.evaluate(doc, XPathConstants.STRING);
				HashMap<String, String> vars = getDefaultDescriptionVars();
				if ( component.indexOf("js_mode") != -1 ) {
					vars.put( "description title", "JavaScript<br>\nNotes" );
				}
				if ( !result.equals("") )
				{
					vars.put( "description text", result );
					result = templateWriter.writePartial( "description.partial.html", vars );
				}
				desc += result;
			}
			catch ( XPathExpressionException e)
			{
				System.out.println("Error getting description from xml with expression: //" + component);
				e.printStackTrace();
			}
		}

		return desc;
	}

	protected static HashMap<String, String> getDefaultDescriptionVars ()
	{
		HashMap<String, String> vars = new HashMap<String, String>();
		vars.put("description title", "Description");
		vars.put("description text", "");
		return vars;
	}

	protected static String getTimestamp() {
		Calendar now = Calendar.getInstance();
		Locale us = new Locale("en");

		return now.getDisplayName(Calendar.MONTH, Calendar.LONG, us)
				+ " "
				+ now.get(Calendar.DAY_OF_MONTH)
				+ ", "
				+ now.get(Calendar.YEAR)
				+ " "
				+ FileUtils.nf(now.get(Calendar.HOUR), 2)
				+ ":"
				+ FileUtils.nf(now.get(Calendar.MINUTE), 2)
				+ ":"
				+ FileUtils.nf(now.get(Calendar.SECOND), 2)
				+ now.getDisplayName(Calendar.AM_PM, Calendar.SHORT, us)
						.toLowerCase()
				+ " "
				+ TimeZone.getDefault().getDisplayName(
						TimeZone.getDefault().inDaylightTime(now.getTime()),
						TimeZone.SHORT, us);
	}

	/*
	 * Get all the syntax possibilities for a method
	 */
	protected static ArrayList<HashMap<String, String>> getSyntax(MethodDoc doc, String instanceName) throws IOException
	{
		TemplateWriter templateWriter = new TemplateWriter();
		ArrayList<HashMap<String, String>> ret = new ArrayList<HashMap<String,String>>();

		for( MethodDoc methodDoc : doc.containingClass().methods() )
		{
			if(Shared.i().shouldOmit(methodDoc)){
				continue;
			}
			if( methodDoc.name().equals(doc.name() ))
			{
				HashMap<String, String> map = new HashMap<String, String>();
				map.put("name", methodDoc.name());
				map.put("object", instanceName);

				ArrayList<HashMap<String, String>> parameters = new ArrayList<HashMap<String,String>>();
				for( Parameter p : methodDoc.parameters() )
				{
					HashMap<String, String> paramMap = new HashMap<String, String>();
					paramMap.put("parameter", p.name());
					parameters.add(paramMap);
				}
				String params = templateWriter.writeLoop("method.parameter.partial.html", parameters, ", ");

				map.put("parameters", params);
				if( ! ret.contains(map) )
				{
					//don't put in duplicate function syntax
					ret.add(map);
				}
			}
		}
		return ret;
	}

	private static String removePackage(String name)
	{ // keep everything after the last dot
		if( name.contains(".") )
		{ return name.substring( name.lastIndexOf(".") + 1 ); }
		return name;
	}

	private static String nameInPDE(String fullName)
	{
		if( fullName.contains("<") && fullName.endsWith(">") )
		{	// if this type uses Java generics
			String parts[] = fullName.split("<");
			String generic = removePackage( parts[0] );
			String specialization = removePackage( parts[1] );
			specialization = specialization.substring( 0, specialization.length() - 1 );
			return generic + "&lt;" + specialization + "&gt;";
		}
		return removePackage( fullName );
	}

	protected static String getUsage(ProgramElementDoc doc){
		Tag[] tags = doc.tags("usage");
		if(tags.length != 0){
			return tags[0].text();
		}
		tags = doc.containingClass().tags("usage");
		if(tags.length != 0){
			return tags[0].text();
		}
		// return empty string if no usage is found
		return "";
	}

	protected static String getInstanceName(ProgramElementDoc doc){
		Tag[] tags = doc.containingClass().tags("instanceName");
		if(tags.length != 0){
			return tags[0].text().split("\\s")[0];
		}
		return "";
	}

	protected static String getInstanceDescription(ProgramElementDoc doc){
		Tag[] tags = doc.containingClass().tags("instanceName");
		if(tags.length != 0){
			String s = tags[0].text();
			return s.substring(s.indexOf(" "));
		}
		return "";
	}

	protected static String getParameters(MethodDoc doc) throws IOException{
		//get parent
		ClassDoc cd = doc.containingClass();
		ArrayList<HashMap<String, String>> ret = new ArrayList<HashMap<String,String>>();

		if(!Shared.i().isRootLevel(cd)){
			//add the parent parameter if this isn't a function of PApplet
			HashMap<String, String> parent = new HashMap<String, String>();
			parent.put("name", getInstanceName(doc));
			parent.put("description", cd.name() + ": " + getInstanceDescription(doc));
			ret.add(parent);
		}

		//get parameters from this and all other declarations of method
		for( MethodDoc m : cd.methods() ){
			if(Shared.i().shouldOmit(m)){
				continue;
			}
			if(m.name().equals(doc.name())){
				ret.addAll(parseParameters(m));
			}
		}

		removeDuplicateParameters(ret);


		TemplateWriter templateWriter = new TemplateWriter();
		return templateWriter.writeLoop("parameter.partial.html", ret);
	}

	protected static String getParameters(ClassDoc doc) throws IOException{
		ArrayList<HashMap<String, String>> ret = new ArrayList<HashMap<String,String>>();
		for( ConstructorDoc m : doc.constructors() ){
			if(Shared.i().shouldOmit(m)){
				continue;
			}
			ret.addAll(parseParameters(m));
		}
		removeDuplicateParameters(ret);

		TemplateWriter templateWriter = new TemplateWriter();
		return templateWriter.writeLoop("parameter.partial.html", ret);
	}

	protected static void removeDuplicateParameters(ArrayList<HashMap<String, String>> ret){
		// combine duplicate parameter names with differing types
		for(HashMap<String, String> parameter : ret)
		{
			String desc = parameter.get("description");
			if(!desc.endsWith(": "))
			{
				// if the chosen description has actual text
				// e.g. float: something about the float
				for(HashMap<String, String> parameter2 : ret)
				{
					String desc2 = parameter2.get("description");

					if( desc2.endsWith(": ") && parameter2.get("name").equals( parameter.get("name") ) )
					{
						// freshen up our variable with the latest description
						desc = parameter.get("description");

						if( ! desc.contains( desc2.substring( 0, desc2.indexOf(": ") ) ) )
						{
							// if the similar item doesn't have actual text
							// e.g. Boolean:
							String newDescription = desc2.replace(":", ",").concat( desc );
							parameter.put("description", newDescription);
						}
					}
				}
			}
		}
		//remove parameters without descriptions
		for( int i=ret.size()-1; i >= 0; i-- )
		{
			if(ret.get(i).get("description").endsWith(": "))
			{
				ret.remove(i);
			}
		}

		// add "or" (split first to make sure we don't mess up the written description)
		for( HashMap<String, String> param : ret )
		{
			String desc = param.get("description");
			String start = desc.substring( 0, desc.indexOf(":")+1 ).replaceFirst( ",([^,]+:)", ", or$1" );
			String end = desc.substring( desc.indexOf(":")+1, desc.length() );

			param.put( "description", start.concat( end ) );
		}
	}

	protected static ArrayList<HashMap<String, String>> parseParameters(ExecutableMemberDoc doc){
		ArrayList<HashMap<String, String>> ret = new ArrayList<HashMap<String,String>>();
		for( Parameter param : doc.parameters()){
			String type = getSimplifiedType( nameInPDE(param.type().toString()) ).concat(": ");
			String name = param.name();
			String desc = "";

			for( ParamTag tag : doc.paramTags() ){
				if(tag.parameterName().equals(name)){
					desc = desc.concat( tag.parameterComment() );
				}
			}

			HashMap<String, String> map = new HashMap<String, String>();
			map.put("name", name);
			map.put("description", type + desc);
			ret.add(map);
		}
		return ret;
	}

	/**
	 *	Modes should support all API, so if XML not explicitly states "not supported", then assume it does.
	 */
	protected static boolean isModeSupported ( ProgramElementDoc doc, String mode ) {

		Document xmlDoc = null;
		try {
			String xmlPath = getXMLPath( doc );
			xmlDoc = getXMLDocument( xmlPath );
		} catch ( IOException ioe ) {
			ioe.printStackTrace();
			return true;
		}

		XPathFactory xpathFactory = XPathFactory.newInstance();
		XPath xpath = xpathFactory.newXPath();

		try {

			String umraw = xpath.evaluate("//unsupported_modes", xmlDoc, XPathConstants.STRING).toString();
			String[] ums = umraw.split(",");
			for ( String s : ums ) {
				if ( s.trim().toLowerCase().equals(mode) )
					return false;
			}

		} catch ( XPathExpressionException e ) {

			e.printStackTrace();
		}

		return true;
	}

	protected static ArrayList<SeeTag> getAllSeeTags( ProgramElementDoc doc )
	{
		ArrayList<SeeTag> ret = new ArrayList<SeeTag>();
		ClassDoc cd = doc.containingClass();
		if( cd != null )
		{	// if there is a containing class, get @see tags for all
			// methods with the same name as this one
			// Fixes gh issue 293
			for( MethodDoc m : cd.methods() )
			{
				if(m.name().equals(doc.name()))
				{
					for( SeeTag tag : m.seeTags() )
					{
						ret.add( tag );
					}
				}
			}
		}
		else
		{	// if no containing class (e.g. doc is a class)
			// just grab the see tags in the class doc comment
			for( SeeTag tag : doc.seeTags() )
			{
				ret.add( tag );
			}
		}
		return ret;
	}

	protected static String getRelated( ProgramElementDoc doc ) throws IOException
	{
		TemplateWriter templateWriter = new TemplateWriter();
		ArrayList<HashMap<String, String>> vars = new ArrayList<HashMap<String,String>>();

		HashMap<String, ProgramElementDoc> classMembers = new HashMap<String, ProgramElementDoc>();

		if( doc.isMethod() || doc.isField() )
		{
			ClassDoc containingClass = doc.containingClass();
			// consider only doing this if we aren't in the core
			// doing this in the core protects against errant references to PGraphics
			// if( !containingClass.name().equalsIgnoreCase("PApplet") )
			{
				for( MethodDoc m : containingClass.methods() )
				{
					if( needsWriting( m ) )
					{
						classMembers.put( m.name(), m );
					}
				}
				for( FieldDoc f : containingClass.fields() )
				{
					if( needsWriting( f ) )
					{
						classMembers.put( f.name(), f );
					}
				}
			}
		}

		// add link to each @see item
		for( SeeTag tag : getAllSeeTags( doc ) ){
			HashMap<String, String> map = new HashMap<String, String>();

			ProgramElementDoc ref = tag.referencedClass();
			if( tag.referencedMember() != null )
			{
				ref = tag.referencedMember();
				if( classMembers.containsKey( ref.name() ) )
				{
					ref = classMembers.get( ref.name() );
				}
			}

			if( needsWriting( ref ) )
			{
				// add links to things that are actually written
				map.put("name", getName( ref ));
				map.put("anchor", getAnchor( ref ));
				vars.add(map);
			}
		}

		// add link to each @see_external item
		for( Tag tag : doc.tags( Shared.i().getSeeAlsoTagName() ) )
		{
			// get xml for method
			String filename = tag.text() + ".xml";
			String basePath = Shared.i().getXMLDirectory();
			File f = new File( basePath + filename );

			if( ! f.exists() )
			{
				basePath = Shared.i().getIncludeDirectory();
				f = new File( basePath + filename );
			}

			if( f.exists() )
			{
				Document xmlDoc = Shared.loadXmlDocument( f.getPath() );
				XPathFactory xpathFactory = XPathFactory.newInstance();
				XPath xpath = xpathFactory.newXPath();

				try
				{
					String name = (String) xpath.evaluate("//name", xmlDoc, XPathConstants.STRING);
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

					// get method name from xml
					// get anchor from method name
					HashMap<String, String> map = new HashMap<String, String>();
					map.put( "name", name );
					map.put( "anchor", anchor );
					vars.add( map );
				} catch (XPathExpressionException e)
				{
					e.printStackTrace();
				}

			}

		}

		return templateWriter.writeLoop("related.partial.html", vars);
	}

	protected static String getEvents(ProgramElementDoc doc){
		return "";
	}

}
