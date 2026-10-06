package Comparable;

import java.util.Comparator;
import java.util.Objects;

public class Student implements Comparable<Student>{

    public static Comparator<Student> SORT_BY_GRADE = new Comparator<Student>(){
        @Override
        public int compare(Student o1, Student o2){
            if(o1.gradeAverage > o2.gradeAverage){
                return 1;
            } else if(o1.gradeAverage < o2.gradeAverage){
                return -1;
            } else {
                return 0;
            }
        }
    };

    private int studentId;
    private String name;
    private int age;
    private String familyName;
    private double gradeAverage;

    public Student(int )



}
