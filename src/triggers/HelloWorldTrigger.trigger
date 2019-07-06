//
// This trigger is to call Hello World Class.
//
trigger HelloWorldTrigger on Account (before insert, before update) {
    HelloWorld3 hw=new HelloWorld3();
    hw.displayHellowWorld();

}