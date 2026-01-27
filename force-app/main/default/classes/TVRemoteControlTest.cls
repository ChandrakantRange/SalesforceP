1@IsTest
2class TVRemoteControlTest {
3    @IsTest 
4    static void testVolumeIncrease() {
5        TVRemoteControl rc = new TVRemoteControl(10);
6        Integer newVolume = rc.increaseVolume(15);
7        System.assertEquals(25, newVolume);
8    }
9    
10    @IsTest
11    static void testVolumeDecrease() {
12        TVRemoteControl rc = new TVRemoteControl(20);
13        Integer newVolume = rc.decreaseVolume(15);
14        System.assertEquals(5, newVolume);        
15    } 
16        
17    @IsTest
18    static void testVolumeIncreaseOverMax() {
19        TVRemoteControl rc = new TVRemoteControl(10);
20        Integer newVolume = rc.increaseVolume(100);
21        System.assertEquals(50, newVolume);        
22    }
23    
24    @IsTest
25    static void testVolumeDecreaseUnderMin() {
26        TVRemoteControl rc = new TVRemoteControl(10);
27        Integer newVolume = rc.decreaseVolume(100);
28        System.assertEquals(0, newVolume);        
29    }
30    
31    @IsTest
32    static void testGetMenuOptions() {
33        // Static method call. No need to create a class instance.
34        String menu = TVRemoteControl.getMenuOptions();
35        System.assertNotEquals(null, menu);
36        System.assertNotEquals('', menu);
37    }
38}