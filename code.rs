fn main() {
    let org = box 5i;

    println!("{}", org);

    let stolen = org;

    println!("{}", org);
}
