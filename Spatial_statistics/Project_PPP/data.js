/*var pWGS84 = new LatLon(51.4778, -0.0016, LatLon.datum.WGS84);  */
/*var pOSGB = pWGS84.convertDatum(LatLon.datum.OSGB36);    */
/*var grid = OsGridRef.parse('TG5140913177') */
/*var pWgs84 = OsGridRef.osGridToLatLon(grid)*/
/*console.log(grid.easting)*/

workbook = XLSX.readFile('dataset_input_total.xlsx');  
first_sheet_name = workbook.SheetNames[0];         
worksheet = workbook.Sheets[first_sheet_name];   
range = {s:{c:2,r:1},e:{c:2,r:144311}};                              
for(var R = range.s.r; R <= range.e.r; ++R) {             
 for(var C = range.s.c; C <= range.e.c; ++C) {           
   var cell_address = {c:C, r:R};                               
   cell_ref = XLSX.utils.encode_cell(cell_address);
   desired_cell = worksheet[cell_ref];
   if(desired_cell === undefined) continue;
   desired_value = desired_cell.v;
   
   try{var grid = OsGridRef.parse(desired_value)
         }
  catch(e){continue;}
   /*console.log(grid.easting)*/
   cell_addressN = {c:10, r:R};
   cell_addressE = {c:11, r:R};
   cell_refN = XLSX.utils.encode_cell(cell_addressN);
   cell_refE = XLSX.utils.encode_cell(cell_addressE);
   worksheet[cell_refN]={t:'n', v:grid.northing};
   worksheet[cell_refE]={t:'n', v:grid.easting};
  }
}
XLSX.writeFile(workbook, 'dataset_output_total.xlsx');
