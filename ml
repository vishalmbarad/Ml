MAPREDUCE COMPLETE DOCUMENT
=== ORIGINAL TXT FILE CONTENT ===
>>> Map Reduce <<<
>> Create a MyMenu db with a Collection called Restraunts containing Documents with
Same or All of the following Fields => RestrauntId, RestrauntName, Grades, Cuisine,
DOE, Rating
#1 >> Insert at Least 10 Documents in the above collection
#2 >> Use Map Reduce Function to Display Total Rating for Every Restraunt
|1|
-- use Mydb
-- db.createCollection("Restraunts")
-- db.Restraunts.insertMany([
{
RestrauntId:101,
RestrauntName: "Salva",
Grades: "3 star",
Cuisine: ["Indian","Veg","Non Veg","Chinese"],
DOE: "1-1-2001",
Rating: 4
},
{
RestrauntId:102,
RestrauntName: "Sufra",
Grades: "3 star",
Cuisine: ["Indian","Non Veg"],
DOE: "12-11-2008",
Rating: 4.5
},
{
RestrauntId:103,
RestrauntName: "South King",
Grades: "2 star",
Cuisine: ["Indian","Veg","South Indian"],
DOE: "17-11-2012",
Rating: 3
},
{
RestrauntId:102,
RestrauntName: "Sufra",
Grades: "3 star",
Cuisine: ["Indian","Non Veg"],
DOE: "12-11-2008",
Rating: 3.8
},
{
RestrauntId:105,
RestrauntName: "China Town",
Grades: "3.5 star",
Cuisine: ["Non Veg","Chinese"],
DOE: "10-6-2013",
Rating: 3.8
},
{
RestrauntId:105,
RestrauntName: "China Town",
Grades: "3.5 star",
Cuisine: ["Non Veg","Chinese"],
DOE: "10-6-2013",
Rating: 3
},
{
RestrauntId:107,
RestrauntName: "Moti Mahal",
Grades: "4 star",
Cuisine: ["Indian","Veg","Non Veg"],
DOE: "11-10-2009",
Rating: 4
},
{
RestrauntId:101,
RestrauntName: "Salva",
Grades: "3.5 star",
Cuisine: ["Indian","Veg","Non Veg","Chinese"],
DOE: "1-1-2001",
Rating: 3.5
},
{
RestrauntId:103,
RestrauntName: "South King",
Grades: "4 star",
Cuisine: ["Indian","Veg","South Indian"],
DOE: "17-11-2012",
Rating: 4
},
{
RestrauntId:107,
RestrauntName: "Moti Mahal",
Grades: "4 star",
Cuisine: ["Indian","Veg","Non Veg"],
DOE: "11-10-2009",
Rating: 3.5
},
]);
--------------------------------------
Map Reduce
db.Restraunts.mapReduce(
function() {
emit(this.RestrauntId, this.Rating);
},
function(key, values) {
return Array.sum(values);
},
{
out: "TotalRatings"
}
);
db.TotalRatings.find().pretty();
=== ADDITIONAL MAPREDUCE CODES ===
=============================
ALL MAP-REDUCE CODES
=============================
1. TOTAL RATING PER RESTAURANT
--------------------------------
db.Restraunts.mapReduce(
function() {
emit(this.RestrauntId, this.Rating);
},
function(key, values) {
return Array.sum(values);
},
{
out: "TotalRatings"
}
);
2. AVERAGE RATING PER RESTAURANT
--------------------------------
var mapFunc = function () {
emit(this.RestrauntId, { rating: this.Rating, count: 1 });
};
var reduceFunc = function (key, values) {
let total = 0;
let count = 0;
values.forEach(v => {
total += v.rating;
count += v.count;
});
return { rating: total, count: count };
};
var finalizeFunc = function (key, reducedVal) {
reducedVal.avgRating = reducedVal.rating / reducedVal.count;
return reducedVal;
};
db.Restraunts.mapReduce(
mapFunc,
reduceFunc,
{
out: "AvgRating",
finalize: finalizeFunc
}
);
3. HIGHEST RATING PER RESTAURANT
---------------------------------
db.Restraunts.mapReduce(
function() {
emit(this.RestrauntId, this.Rating);
},
function(key, values) {
return Math.max.apply(null, values);
},
{
out: "MaxRating"
}
);
4. LOWEST RATING PER RESTAURANT
---------------------------------
db.Restraunts.mapReduce(
function() {
emit(this.RestrauntId, this.Rating);
},
function(key, values) {
return Math.min.apply(null, values);
},
{
out: "MinRating"
}
);
5. COUNT RESTAURANTS PER CUISINE
---------------------------------
var mapCuisine = function () {
this.Cuisine.forEach(c => emit(c, 1));
};
var reduceCuisine = function (key, values) {
return Array.sum(values);
};
db.Restraunts.mapReduce(
mapCuisine,
reduceCuisine,
{ out: "CuisineCount" }
);
6. TOTAL RESTAURANTS OPENED PER YEAR
-------------------------------------
var mapDOE = function () {
var year = this.DOE.split("-")[2];
emit(year, 1);
};
var reduceDOE = function (key, values) {
return Array.sum(values);
};
db.Restraunts.mapReduce(
mapDOE,
reduceDOE,
{ out: "RestaurantsPerYear" }
);
7. CUISINE-WISE AVERAGE RATING
--------------------------------
var mapCuisineAvg = function () {
this.Cuisine.forEach(c => {
emit(c, { rating: this.Rating, count: 1 });
});
};
var reduceCuisineAvg = function (key, values) {
let total = 0, count = 0;
values.forEach(v => {
total += v.rating;
count += v.count;
});
return { rating: total, count: count };
};
var finalizeCuisineAvg = function (key, reducedVal) {
reducedVal.avgRating = reducedVal.rating / reducedVal.count;
return reducedVal;
};
db.Restraunts.mapReduce(
mapCuisineAvg,
reduceCuisineAvg,
{ out: "CuisineAvg", finalize: finalizeCuisineAvg }
);
8. GRADE-WISE RESTAURANT COUNT
-------------------------------
var mapGrade = function () {
emit(this.Grades, 1);
};
var reduceGrade = function (key, values) {
return Array.sum(values);
};
db.Restraunts.mapReduce(
mapGrade,
reduceGrade,
{ out: "GradeCount" }
);
9. LIST OF RESTAURANTS PER CUISINE
------------------------------------
var mapList = function () {
this.Cuisine.forEach(c => {
emit(c, this.RestrauntName);
});
};
var reduceList = function (key, values) {
return values;
};
db.Restraunts.mapReduce(
mapList,
reduceList,
{ out: "CuisineWiseList" }
);
10. FULL ANALYTICS PACK
------------------------
db.Restraunts.mapReduce(
function() {
emit(this.RestrauntName, {
ratings: [this.Rating],
count: 1
});
},
function(key, values) {
var arr = [];
var count = 0;
values.forEach(v => {
arr = arr.concat(v.ratings);
count += v.count;
});
return { ratings: arr, count: count };
},
{
out: "FullRestaurantStats",
finalize: function(key, reducedVal) {
var sum = reducedVal.ratings.reduce((a,b)=>a+b,0);
reducedVal.totalRating = sum;
reducedVal.avgRating = sum / reducedVal.count;
reducedVal.maxRating = Math.max.apply(null, reducedVal.ratings);
reducedVal.minRating = Math.min.apply(null, reducedVal.ratings);
return reducedVal;
}
}
);
