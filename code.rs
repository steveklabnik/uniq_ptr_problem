fn main() {
    let org = Box::new(5);

    println!("{}", org);

    let stolen = org;

    println!("{}", org);
}
