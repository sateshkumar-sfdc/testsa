trigger HelloSFDCTrigger on Account (before insert, Before update) {
    HelloSFDC hS = new HelloSFDC();
    hS.displayHelloSFDC();

}