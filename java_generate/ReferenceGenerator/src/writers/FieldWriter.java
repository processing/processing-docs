package writers;
import java.io.IOException;
import java.util.HashMap;

import com.sun.javadoc.ClassDoc;
import com.sun.javadoc.FieldDoc;


public class FieldWriter extends BaseWriter {
	
	/**
	 * 
	 * @param vars inherited from containing ClassDoc
	 * @param doc
	 * @throws IOException
	 */
	
	public static void write(HashMap<String, String> vars, FieldDoc doc) throws IOException
	{
		String filename = getAnchor(doc);
		TemplateWriter templateWriter = new TemplateWriter();
		vars.put("examples", getExamples(doc));
		//grab the description
		//change to basicText(doc) to get text from source code
		vars.put("description", getXMLDescription(doc));
		vars.put("name", getName(doc));
		vars.put("usage", getUsage(doc));
		vars.put("related", getRelated(doc));
		
		if(Shared.i().isRootLevel(doc.containingClass())){
			vars.put("classname", "");
		} else {
			vars.put("classanchor", getLocalAnchor(doc.containingClass()));
			vars.put("parameters", templateWriter.writePartial("parameter.partial.html", getParent(doc)));			
			String syntax = templateWriter.writePartial("field.syntax.partial.html", getSyntax(doc));
			vars.put("syntax", syntax);	
		}
		
		templateWriter.write("generic.template.html", vars, filename);
	}
	
	
	public static void write(FieldDoc doc) throws IOException
	{
		write(new HashMap<String, String>(), doc);
	}
	
	
	
	protected static HashMap<String, String> getSyntax(FieldDoc doc){
		HashMap<String, String> map = new HashMap<String, String>();
		map.put("object", getInstanceName(doc));
		map.put("field", getName(doc));
		return map;
	}
	
	protected static HashMap<String, String> getParent(FieldDoc doc){
		HashMap<String, String> parent = new HashMap<String, String>();
		ClassDoc cd = doc.containingClass();
		parent.put("name", getInstanceName(doc));
		parent.put("description", cd.name() + ": " + getInstanceDescription(doc));
		return parent;
	}

}
