drop database if exists mock;
create database mock;
use mock;
create table courses (
`course_id` int primary key,
`course_name`varchar(100) not null,
`course_code`varchar(20) not null unique,
`department`varchar(100) not null,
`creation_date` date )
create table students(
`student_id` int primary key,
`full_name` varchar(100) not null,
`major` varchar(100) not null,
`phone_number`varchar(15) not null unique,
`gpa`decimal(3,1) default 4.0
check(gpa>=0.0 and gpa<=4.0))
create table enrollments(
`enrollment_id` int primary key,
`course_id` int,
`student_id`int,
`enroll_time`datetime not null,
`credits`int check ( credits >0),
`status`varchar(50),
foreign key (course_id) references courses(course_id),
foreign key (student_id) references students(student_id))
create table enrollment_details(
`detail_id` int primary key,
`enrollment_id`int,
`attendance_check`varchar(150),
`detail_date`datetime default current_timestamp,
foreign key(enrollment_id) references enrollments(enrollment_id))
create table academic_logs(
`log_id` int primary key,
`enrollment_id`int,
`student_id` int,
`log_time`datetime not null,
`note`text,
foreign key(enrollment_id) references enrollments(enrollment_id),
foreign key(student_id) references students(student_id))
insert into courses(course_id,course_name,course_code,department,creation_date)
values(1, 'Lập trình Java', 'JAVA01', 'CNTT', '2023-12-03'),
(2, 'Cấu trúc dữ liệu', 'DSA02', 'Khoa học máy tính', '1996-11-25'),
(3, 'Cơ sở dữ liệu', 'SQL03', 'CNTT', '2001-07-08'),
(4, 'Mạng máy tính', 'NET04', 'Truyền thông', '1998-01-19'),
(5, 'Trí tuệ nhân tạo', 'AI05', 'Khoa học máy tính', '2000-09-03')
insert into students(student_id,full_name,major,phone_number,gpa)
values(1, 'Nguyễn Văn Hải', 'Hệ thống TT', '0931112223', 3.8),
(2, 'Trần Thu Hà', 'Kỹ thuật PM', '0932223334', 4.0),
(3, 'Lê Quốc Tuấn', 'An toàn TT', '0933334445', 3.6),
(4, 'Phạm Minh Châu', 'Dữ liệu lớn', '0934445556', 3.9),
(5, 'Hoàng Gia Bảo', 'Kỹ thuật PM', '0935556667', 3.7)
insert into enrollments(enrollment_id,course_id,student_id,enroll_time,credits,status)
values(7001, 1, 1, '2024-05-20 08:00:00', 3, 'Pending'),
(7002, 2, 2, '2024-05-20 09:30:00', 4, 'Completed'),
(7003, 3, 3, '2024-05-20 10:15:00', 3, 'Pending'),
(7004, 4, 5, '2024-05-21 07:00:00', 3, 'Completed'),
(7005, 5, 4, '2024-05-21 08:45:00', 4, 'Dropped')
insert into enrollment_details(detail_id, enrollment_id, attendance_check, detail_date)
values(8001, 7002, 'Đủ điều kiện thi', '2024-05-20 10:00:00'),
(8002, 7004, 'Vắng 1 buổi', '2024-05-21 08:00:00'),
(8003, 7001, 'Đang học', '2024-05-20 09:00:00'),
(8004, 7003, 'Nghỉ phép', '2024-05-20 11:00:00'),
(8005, 7005, 'Không đi học', '2024-05-21 09:00:00')
insert into academic_logs(log_id,enrollment_id,student_id,log_time,note)
values(1, 7001, 1, '2024-05-20 09:05:00', 'Bắt đầu lớp học'),
(2, 7002, 2, '2024-05-20 10:05:00', 'Hoàn tất môn học'),
(3, 7003, 3, '2024-05-20 11:10:00', 'Đang sắp xếp lịch bù'),
(4, 7004, 5, '2024-05-21 08:10:00', 'Chờ phê duyệt điểm'),
(5, 7005, 4, '2024-05-21 09:05:00', 'Hủy do vắng quá số buổi')enrollmentscoursescourses
update enrollments as e
join courses as c on e.course_id = c.course_id
set e.credits = e.credits + 1
where e.status = 'Completed'
and c.creation_date < '2001-01-01'
SET SQL_SAFE_UPDATES = 0;
delete from academic_logs where log_time<'2024-05-20 00:00:00';
p3
select full_name,major,gpa 
from students 
where gpa > 3.8 
 major = 'Kỹ thuật PM';
select course_name,course_code 
from courses 
where creation_date 
between '1998-01-01' and '2001-12-31' 
and course_code like 'A%';
select enrollment_id,enroll_time,credits 
from enrollments 
order by credits desc 
limit 2 offset 2;
p4
select c.course_name,s.full_name,s.major,e.credits,e.enroll_time
from enrollments as e
join courses as c 
on e.course_id = c.course_id
join students as s 
on e.student_id = s.student_id;

select s.full_name, sum(e.credits) 
from students as s 
join enrollments as e 
on s.student_id = e.student_id 
where e.status = 'Completed' 
group by s.student_id, s.full_name 
having sum(e.credits)>120;

select student_id,full_name,gpa 
from students 
order by gpa desc;
p5
create index idx_enrollments_status_credits
on enrollments (status, credits);

create view summarry as select s.full_name, count(e.enrollment_id),sum(e.credits) 
from students as s 
join enrollments as e 
on s.student_id = e.student_id 
where e.status <>'Dropped' 
group by s.full_name, s.student_id;
select*from summarry
