mod list;
use list::{parallel_map};

fn main() {
    let data = vec![1, 2, 3, 4, 5];

    let mapped_data = parallel_map(&data, &|x| x * 2);
    println!("Mapped Data: {:?}", mapped_data);
}
