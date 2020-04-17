SET SERVEROUTPUT ON
DECLARE
   CURSOR c1 is
      SELECT dept_name  
      FROM department;
        
   x_id   VARCHAR(5);
   x_name VARCHAR(20);
   x_dept_name varchar(20);
   x_title varchar(100);
   x_semester varchar(8);
   x_year numeric(4,0);
   x_total_cred numeric(3,0);
   x_grade varchar(2);
   x_grade2 number := 0;
   takes_count number := 0;
   
   CURSOR c2 is
      SELECT ID, name, dept_name, 
      (select sum(credits) from course, takes where takes.ID = student.ID and takes.course_id = course.course_id) as total_cred,
      (select count(*) from course, takes where takes.ID = student.ID and takes.course_id = course.course_id) as takes_count
      FROM student
      WHERE dept_name = x_dept_name;
    
   CURSOR c3 is
      SELECT ID, semester, year, grade, (select title from course where course.course_id = takes.course_id) as title
      FROM takes
      WHERE ID = x_id;   

BEGIN
   OPEN c1;
   LOOP
      FETCH c1 INTO x_dept_name;
      EXIT WHEN c1%NOTFOUND;
      dbms_output.put_line (x_dept_name);
      open c2;
      loop
          fetch c2 into x_id, x_name, x_dept_name, x_total_cred, takes_count;
          exit when c2%NOTFOUND;
          dbms_output.put_line ('       '||x_name);
          x_grade2 := 0;
          takes_count := 0;
          open c3;
          loop
              fetch c3 into x_id, x_semester, x_year, x_grade, x_title;
              exit when c3%NOTFOUND;
                 IF x_grade = 'A+' then x_grade2:= x_grade2 + 4.3;
               ELSIF x_grade = 'A' then x_grade2:=x_grade2 + 4.0;
               ELSIF x_grade = 'A-' then x_grade2:=x_grade2 + 3.7;
               ELSIF x_grade = 'B+' then x_grade2:=x_grade2 + 3.3;
               ELSIF x_grade = 'B' then x_grade2:=x_grade2 + 3.0;
               ELSIF x_grade = 'B-' then x_grade2:=x_grade2 + 2.7;
               ELSIF x_grade = 'C+' then x_grade2:=x_grade2 + 2.3;
               ELSIF x_grade = 'C' then x_grade2:=x_grade2 + 2.0;
               ELSIF x_grade = 'C-' then x_grade2:=x_grade2 + 1.7;
               ELSIF x_grade = 'F' then x_grade2:=x_grade2 + 0.0;
               END IF;
               takes_count := takes_count + 1;
               dbms_output.put_line ('            '||x_title||'  '||x_semester||'  '||x_year||'  '||x_grade);
          end loop;
          if takes_count = 0 then takes_count := 1;
          end if;
          dbms_output.put_line ('            총 이수학점: '||x_total_cred||'  평점: '||x_grade2/takes_count);
          close c3;
      end loop;
      close c2;
   END LOOP;
   CLOSE c1;
END;