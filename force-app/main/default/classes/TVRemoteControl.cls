1public class TVRemoteControl {
2    // Volume to be modified
3    Integer volume;
4    // Constant for maximum volume value
5    static final Integer MAX_VOLUME = 50;    
6    
7    // Constructor
8    public TVRemoteControl(Integer v) {
9        // Set initial value for volume
10        volume = v;
11    }
12        
13    public Integer increaseVolume(Integer amount) {
14        volume += amount;
15        if (volume > MAX_VOLUME) {
16            volume = MAX_VOLUME;
17        } 
18        return volume;
19    }
20    
21    public Integer decreaseVolume(Integer amount) {
22        volume -= amount;
23        if (volume < 0) {
24            volume = 0;
25        }  
26        return volume;
27    }    
28    
29    public static String getMenuOptions() {
30        return 'AUDIO SETTINGS - VIDEO SETTINGS';
31    }
32       
33}