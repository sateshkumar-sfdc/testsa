trigger Helloworld9Trigger on Account (before insert, before update) {

HelloWorld9 hw=new HelloWorld9();
hw.helloWorld9();

}