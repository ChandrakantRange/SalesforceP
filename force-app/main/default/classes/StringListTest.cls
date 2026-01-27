public class StringListTest {
    
    public static list<string> generateStringList (Integer numStrings){
        List<String> stringList = new List<String>();
        
        
        for (Integer i = 0; i < numStrings; i++) {
           
            stringList.add('Test ' + i);
        }
        
       
        return stringList;
        
    }

}