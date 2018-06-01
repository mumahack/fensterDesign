
small = [450, 815]; //2x 45cm by 81.5cm
big = [530, 895]; // 6x 53cm by 89.5cm
tolerance = 5;


module fenster(letter,area){
        difference(){
            offset(delta =-tolerance) square(area);
            intersection(){
                offset(delta =-20) square(area);
                translate([area[0]/10, area[1]/7]) scale([1.3,1.8])  random_voronoi(n=64, thickness=3.5, round=6, min=0, max=300);
            }
            
        }
        translate([area[0]/10, area[1]/7]) text(letter,size=area[0], font="Mono:style=Bold");
    
}

fenster("#",small);
translate([1*big[0],0]) fenster("m",small);

translate([2.1*big[0],0])  fenster("u",big);
translate([3.2*big[0],0]) fenster("m",big);
translate([4.3*big[0],0]) fenster("a",big);
translate([5.4*big[0],0]) fenster("l",big);
translate([6.5*big[0],0]) fenster("a",big);
translate([7.6*big[0],0]) fenster("b",big);


function normalize(v) = v/(sqrt(v[0]*v[0] + v[1]*v[1]));

module voronoi(points, L=200, thickness=1, round=6, nuclei=true){
	for (p=points){
		difference(){
			minkowski(){
			intersection_for(p1=points){
				if (p!=p1){
					translate((p+p1)/2 - normalize(p1-p) * (thickness+round))
					assign(angle=90+atan2(p[1]-p1[1], p[0]-p1[0])){
						rotate([0,0,angle])
						translate([-L,-L])
						square([2*L, L]);
					}
				}
			}
			circle(r=round, $fn=20);
			}
			if (nuclei)
			translate(p) circle(r=1, $fn=20);
		}
	}
}


module random_voronoi(n=20, nuclei=true, L=200, thickness=1, round=6, min=0, max=100, seed=42){

	x = rands(min, max, n, seed);
	y = rands(min, max, n, seed+1);

	for (i=[0:n-1]){
		difference(){
			minkowski(){
			intersection_for(j=[0:n-1]){
				if (i!=j){
					assign(p=[x[i],y[i]], p1=[x[j],y[j]]){
						translate((p+p1)/2 - normalize(p1-p) * (thickness+round))
						assign(angle=90+atan2(p[1]-p1[1], p[0]-p1[0])){
							rotate([0,0,angle])
							translate([-L,-L])
							square([2*L, L]);
						}
					}
				}
			}
			circle(r=round, $fn=20);
			}
			if (nuclei)
			translate([x[i],y[i]]) circle(r=1, $fn=20);
		}
	}
}

// example with an explicit list of points:
// point_set = [[0,0],[30,0],[20,10],[50,20],[15,30],[85,30],[35,30],[12,60], [45,50],[80,80],[20,-40],[-20,20],[-15,10],[-15,50]];
// voronoi(points=point_set, round=4, nuclei=false);


