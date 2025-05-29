## Future improvements
ETS optimisation. Using stream + async tasks to speed up writing knowledge base to ets for the case that the file size grows drastically. I'm also not really accessing the ETS cache as much as I could be in the code base, because it wasn't front of my mind.

Automated tests! For the sake of time, I omitted basic tests just to get things going. My plan was to add them all at the end if I had time for safety, but did some manual testing along the way. Which looking back, not sure if that helped with speed...

More/improved queries to avoid loading huge amounts of data into memory. For example, there's no need to query the db every time we poll the file, we can just check the ets table to see if it was updated since the last run and if so, write to the db, if not, just carry on. 
On this, data models also need some tidying up, definitely depends on what the team wants to do with the data going forward but I think there's room for improvement. Could be good to figure out the right places to put joins and selects.

Too many generated modules. A lot of the modules in the repo are just generated from Phoenix mix tasks and aren't touched at all. The request life-cycle should be taken into consideration to remove redundancies going forward.
On this, controllers are not thin enough. A lot of heavy lifting is being done in the controllers, which we don't want to see during request time so that we can get a response out as soon as possible. A lot of the logic in the controllers can be moved into context modules or elsewhere.

Error handling. Error handling is not standardised, and can be a bit hard to follow in my approach. Would love to streamline this for better DevEx and UX. For example, in some places I add a rescue, sometimes I let things crash, sometimes it's an error tuple but not enough thought went into what goes where.
This kind of leads into API responses, where there's some lack of standardisation on the responses returned to the user.

Scoring. I confused myself quite a bit trying to understand the project requirements, particularly when it came to scoring. I don't my approach currently makes sense and think it's important to get that feature working down the line.

Utilise scopes or remove them. Having a mix and match of auth whilst trying to move fast was quite unintuitive. It could be nice to allow users to view certain things based on whether or not they are authorised but this is something that has not been properly implemented.

Proper log handling and metrics! I didn't have time for this but think observability goes a long way when it comes to APIs. We can learn more about the users' habits and application performance to keep us on a focused path.