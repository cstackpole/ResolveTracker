ResolveTracker
==============

A Bash utility to track activities you have resolved to do more of.  

This program was originally written to help me stay focused on a resolution and track how frequently I perform that task. Since then I have found it useful for tracking more then just that one task. Thus, I have tried to abstract everything such that it can be used to track near any activity anyone does frequently.   

This is the v1.0 re-write where the original was the 0.x version. The original was completly written in Bash and saved all data in a text file which caused numerous parsing errors on a regular basis. It was clumsy, had lot of bugs if you entered in wrong information, and was generally rather frustrating to use even for myself. It was started long before I really got into Bash programming and it carried along a lot of early bad habits. :-P   

I hope to address all of these issues plus make it functional enough that someone else might find it useful. I have already cleaned up most of the functions, added in a ton of checks for user-input-varification, and have ported it to SQLite instead of a flat-txt-file based db.   

The big TODO items are:   
* The old script has a lot of really nifty, but poorly written, statistics about the activities. I am working to implement them.   
* The old script generated a calendar which I frequently found useful, but it only generated a *full* calendar which means it generated one all the way back to 2005 for me. :-/ Because of how it was originally written I ended up creating a secondary script to handle the output. Not as useful. I would like to create a better calendar function.   
* I have been playing with the KIVI GUI on another project and wouldn't mind making a GUI for this app. But that is a much further along goal.   

The fields tracked are: Date, StartTime, TimeInvested, Tags, Score, Notes   
 Date: The day of the event. (20140128)   
 StartTime: When the event began in HH:MM format (eg: 15:30)   
 TimeInvested: The amount of time invested in the event in minutes. (eg: 70)   
 Tags: Originally "Title", this field allows for comma seperated list of tags for sorting, statistics, and whatnot.   
 Score: Was the effort and time invested worth it? Feel free to leave this 0 I am experimenting with its usefulness.   
 Notes: Any details you might want to associate with this event.   

Exit Codes:   
  1: Function usage called   
  2: Wrong binary   
  3: Need version 3 or better of sqlite   
  4: User bailed on creating a new database   
  5: Found a database file that does not appear to be a SQLite 3.x database   
  6: Found a file the user doesn't want to overwrite.   
  7: Found a database without the RslvTrkr table   
  8: Database entry failed   

Snippet excerpt from the database:   

231|2014-02-24 17:00|120|Workout <Boxing>|50|A ton of up-downs today + far too many squats. My quads are killing me.   
232|2014-02-25 17:30|45|Reading <Fiction>, Game of Thrones|70|Got a few more chapters down in the fourth booth. Got another Arya chapter! :-)   
233|2014-02-25 06:10|50|Workout <TaeKwonDo>,Forms|50|Gah. I need to practice more. I goofed up three of them today.   
234|2014-02-25 18:15|45|Reading <Technology>,Puppet|40|Caught up on some threads and ended up reading a bunch about anchors   
235|2014-02-26 06:10|40|Workout <TaeKwonDo>,Forms,HeavyBags|80|Much better at forms today. Only goofed one. Spent some time kicking the bags.   
236|2014-02-26 16:15|65|Programming <Bash>, Programming <SQLite>, ResolveTracker|80|Knocked out a lot of small bugs; tested new user-input functions; solved the single-quote problem with SQLite. Feel better about posting this code now.   
237|2014-02-26 18:00|120|Workout <Boxing>,HeavyBags|100|Today was a really well rounded workout. I hurt all over and not just one muscle group. :-)   
238|2014-02-27 16:30|180|Programming <Bash>|70|Found a lot more bugs in my code; moved a lot of things into their own functions; split function into its own file to make thing far less cluttered. Will post to Github next time. Don't want to mess with Git tonight.   

This output is the raw form and I am working on making it look better. The thing to notice though is that all of the events are tracked by date along with an approximation on how long I was busy with those events. There is nothing in the program that enforces a specific number so you can be as granular as you want or just always round to the nearest half-hour. Whatever fits you best. Next is the list of events. This is a comma seperated list, but I personally like the <subgroup> notation. However you want to group your tags is up to you. From this list you can deduce that I am trying to: work out more, program more (personal; my boss tracks my professional time ;-), and read more (all types). There are also other tags that I want to track, but I don't care how; like: forms, the name of the book/material, and if I hit the punching/kicking bags that day. Again, tags are however you want to use them, this is just how I use them. Next is the score. This is mostly just something I use to stick a number on the event so I can say "yeah, this was little worse then that event but a LOT better then this other event." Finally, the note is just a description I use to help me remember something about that event that day and why I spent the time doing it.
