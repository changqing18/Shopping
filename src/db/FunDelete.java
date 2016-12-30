package db;

/**
 * Created by 28713 on 2016/12/28.
 */
public class FunDelete {
    public String[][] TranString(String[] array){
        String [][] arr=new String[array.length][3];
        for (int i = 0; i < array.length; i++) {
            arr[i][0]="orderid"+array[i];
            arr[i][1]="gid"+array[i];
            arr[i][2]="number"+array[i];
        }
        return arr;
    }
}
