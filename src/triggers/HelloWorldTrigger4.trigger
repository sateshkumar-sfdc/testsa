trigger HelloWorldTrigger4 on Account (before insert, before update) {
    HelloWorld4 hW =new HelloWorld4();
        hW.displayHelloWorld();
    }