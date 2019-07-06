public class Example5 {
    public string name;
    public string getName(){
        return name;
    }
    public void setName(string name){
        this.name=name;
    }
    public pagereference show(){
        name='this name is '+name;
        return null;
    }

}