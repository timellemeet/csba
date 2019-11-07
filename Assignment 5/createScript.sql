SET FOREIGN_KEY_CHECKS = 0;
drop table if exists classroom;
drop table if exists department;
drop table if exists course;
drop table if exists instructor;
drop table if exists section;
drop table if exists teaches;
drop table if exists student;
drop table if exists takes;
drop table if exists advisor;
drop table if exists time_slot;
drop table if exists prereq;
SET FOREIGN_KEY_CHECKS = 1;

CREATE TABLE classroom
	(
        building    VARCHAR(15),
        room_number VARCHAR(7),
        capacity    NUMERIC(4,0),
        PRIMARY KEY (building, room_number)
	)
    ENGINE=INNODB;

CREATE TABLE department
	(
        dept_name	VARCHAR(20),
        building	VARCHAR(15),
        budget	    NUMERIC(12,2),
        CHECK (budget > 0),
        PRIMARY KEY (dept_name)
	) ENGINE=INNODB;

CREATE TABLE course
	(
        course_id	VARCHAR(8),
        title		VARCHAR(50),
        dept_name	VARCHAR(20),
        credits		NUMERIC(2,0),
        CHECK (credits > 0),
        PRIMARY KEY(course_id),
        CONSTRAINT FOREIGN KEY (dept_name) REFERENCES department(dept_name) ON DELETE SET NULL
	) ENGINE=INNODB;

CREATE TABLE instructor
	(
        ID          VARCHAR(5),
        name        VARCHAR(20) NOT NULL,
        dept_name   VARCHAR(20),
        salary      NUMERIC(8,2),
        CHECK (salary > 29000),
        PRIMARY KEY(ID),
        CONSTRAINT FOREIGN KEY (dept_name) REFERENCES department(dept_name) ON DELETE SET NULL
	) ENGINE=INNODB;

CREATE TABLE section
	(
        course_id		VARCHAR(8),
        sec_id          VARCHAR(8),
        semester		VARCHAR(6),
        CHECK (semester in ('Fall', 'Winter', 'Spring', 'Summer')),
        year			NUMERIC(4,0),
        CHECK (year > 1701 and year < 2100),
        building		VARCHAR(15),
        room_number		VARCHAR(7),
        time_slot_id    VARCHAR(4),
        PRIMARY KEY(course_id, sec_id, semester, year),
        CONSTRAINT FOREIGN KEY (course_id) REFERENCES course(course_id) ON DELETE CASCADE,
        CONSTRAINT FOREIGN KEY (building, room_number) REFERENCES classroom(building, room_number) ON DELETE SET NULL
	) ENGINE=INNODB;

CREATE TABLE teaches
	(
        ID              VARCHAR(5),
        course_id		VARCHAR(8),
        sec_id			VARCHAR(8),
        semester		VARCHAR(6),
        year			NUMERIC(4,0),
        PRIMARY KEY(ID, course_id, sec_id, semester, year),
        CONSTRAINT FOREIGN KEY (course_id, sec_id, semester, year) REFERENCES section(course_id, sec_id, semester, year) ON DELETE CASCADE,
        CONSTRAINT FOREIGN KEY (ID) REFERENCES instructor(ID) ON DELETE CASCADE
	) ENGINE=INNODB;

CREATE TABLE student
	(
        ID              VARCHAR(5),
        name            VARCHAR(20) NOT NULL,
        dept_name		VARCHAR(20),
        tot_cred		NUMERIC(3,0),
        CHECK (tot_cred >= 0),
        PRIMARY KEY(ID),
        CONSTRAINT FOREIGN KEY (dept_name) REFERENCES department(dept_name) ON DELETE SET NULL
	) ENGINE=INNODB;

CREATE TABLE takes
	(
        ID            VARCHAR(5),
        course_id     VARCHAR(8),
        sec_id        VARCHAR(8),
        semester      VARCHAR(6),
        year          NUMERIC(4,0),
        grade         VARCHAR(2),
        PRIMARY KEY(ID, course_id, sec_id, semester, year),
        CONSTRAINT FOREIGN KEY (course_id,sec_id, semester, year) REFERENCES section(course_id,sec_id, semester, year) ON DELETE CASCADE,
        CONSTRAINT FOREIGN KEY (ID) REFERENCES student(ID) ON DELETE CASCADE
	) ENGINE=INNODB;

CREATE TABLE advisor
	(
        s_ID    VARCHAR(5),
        i_ID    VARCHAR(5),
        PRIMARY KEY(s_ID),
        CONSTRAINT FOREIGN KEY (i_ID) REFERENCES instructor(ID) ON DELETE SET NULL,
        CONSTRAINT FOREIGN KEY (s_ID) REFERENCES student(ID) ON DELETE CASCADE
	) ENGINE=INNODB;

CREATE TABLE time_slot
	(
        time_slot_id	VARCHAR(4),
        day			    VARCHAR(1),
        start_hr		NUMERIC(2),
        CHECK (start_hr >= 0 and start_hr < 24),
        start_min		NUMERIC(2),
        CHECK (start_min >= 0 and start_min < 60),
        end_hr			NUMERIC(2),
        CHECK (end_hr >= 0 and end_hr < 24),
        end_min		    NUMERIC(2),
        CHECK (end_min >= 0 and end_min < 60),
        PRIMARY KEY(time_slot_id, day, start_hr, start_min)
	) ENGINE=INNODB;

CREATE TABLE prereq
	(
        course_id		VARCHAR(8),
        prereq_id		VARCHAR(8),
        PRIMARY KEY(course_id, prereq_id),
        CONSTRAINT FOREIGN KEY (course_id) REFERENCES course(course_id) ON DELETE CASCADE,
        CONSTRAINT FOREIGN KEY (prereq_id) REFERENCES course(course_id)
	) ENGINE=INNODB;

