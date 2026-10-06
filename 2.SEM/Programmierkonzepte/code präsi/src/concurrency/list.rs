use rayon::join as forkjoin;

// Parallel Map using ForkJoin
pub fn parallel_map<T, U, F>(data: &[T], f: &F) -> Vec<U>
where
    T: Sync,
    U: Send,
    F: Fn(&T) -> U + Sync,
{
    if data.is_empty() {
        return Vec::new();
    }

    if data.len() == 1 {
        return vec![f(&data[0])];
    }

    let mid = data.len() / 2;
    let (left, right) = data.split_at(mid);

    let (left_result, right_result) = forkjoin(
        || parallel_map(left, f),
        || parallel_map(right, f),
    );

    [left_result, right_result].concat()
}
