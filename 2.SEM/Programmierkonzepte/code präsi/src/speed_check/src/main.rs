use rayon::prelude::*;
use std::time::Instant;

fn main() {
        
    let data: Vec<u64> = (1..=10_000_000).collect();
        
    // Mit map
    let start = Instant::now();
    let _result: Vec<_> = data.iter().map(|x| x.pow(2)).collect();
    println!("Serielle map Dauer: {:?}", start.elapsed());
        
    // Mit parallel_map
    let start = Instant::now();
    let _result: Vec<_> = data.par_iter().map(|x| x.pow(2)).collect();
    println!("Parallele map Dauer: {:?}", start.elapsed());
            
}
