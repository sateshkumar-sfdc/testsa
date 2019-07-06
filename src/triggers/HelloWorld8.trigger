//
// This trigger is to call Hello World Class.
//
trigger HelloWorld8 on Account (before insert, before update) {
    HelloWorld8 hw=new HelloWorld8();
    hw.helloWorld8();

}