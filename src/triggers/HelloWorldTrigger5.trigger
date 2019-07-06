//
// This trigger will run the class object.
//
trigger HelloWorldTrigger5 on Account (before insert, before update) {
    
    HelloWorld5 hW = new HelloWorld5();
    hW.display();

}