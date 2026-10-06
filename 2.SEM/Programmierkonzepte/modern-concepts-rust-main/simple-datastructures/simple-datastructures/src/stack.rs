#[derive(Clone)]
pub struct Node<T> {
    pub data: T,
    pub next: Option<Box<Node<T>>>,
}

#[derive(Clone)]
pub struct Stack<T> {
    pub head: Option<Box<Node<T>>>,
    pub length: i32,
}

impl<T> Stack<T> {
    pub fn new() -> Self {
        Stack {
            head: None,
            length: 0,
        }
    }

    pub fn equals(&self, other: &Stack<T>) -> bool
    where
        T: PartialEq,
    {
        if self.length != other.length {
            return false;
        }

        let mut current_self = &self.head;
        let mut current_other = &other.head;

        while let (Some(node_self), Some(node_other)) = (current_self, current_other) {
            if node_self.data != node_other.data {
                return false;
            }
            current_self = &node_self.next;
            current_other = &node_other.next;
        }

        true
    }

    // Gibt die Liste als String zurück
    pub fn to_string(&self) -> String
    where
        T: ToString,
    {
        let mut result = String::new();
        let mut current = &self.head;

        while let Some(node) = current {
            result.push_str(&node.data.to_string());
            if node.next.is_some() {
                result.push_str(" -> ");
            }
            current = &node.next;
        }

        result
    }

    // Gibt die Größe der Liste zurück
    pub fn size(&self) -> i32 {
        self.length
    }

    // Überprüft, ob die Liste leer ist
    pub fn is_empty(&self) -> bool {
        self.length == 0
    }

    // Überprüft, ob die Liste voll ist
    pub fn is_full(&self) -> bool {
        self.length != 0
    }
    pub fn push(&mut self, data: T) {
        let new_node = Box::new(Node {
            data,
            next: self.head.take(),
        });
        self.head = Some(new_node);
        self.length += 1;
    }

    // Pop-Funktion: Entfernt das oberste Element vom Stack und gibt es zurück
    pub fn pop(&mut self) -> Option<T> {
        if let Some(node) = self.head.take() {
            self.head = node.next;
            self.length -= 1;
            Some(node.data)
        } else {
            None // Wenn der Stack leer ist, geben wir None zurück
        }
    }

}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn test_push_and_pop() {
        let mut stack = Stack::new();
        assert!(stack.is_empty());

        stack.push(1);
        stack.push(2);
        stack.push(3);

        assert_eq!(stack.size(), 3);
        assert_eq!(stack.pop(), Some(3));
        assert_eq!(stack.pop(), Some(2));
        assert_eq!(stack.pop(), Some(1));
        assert!(stack.is_empty());
    }

    #[test]
    fn test_size() {
        let mut stack = Stack::new();
        assert_eq!(stack.size(), 0);

        stack.push(1);
        assert_eq!(stack.size(), 1);
    }

    #[test]
    fn test_to_string() {
        let mut stack = Stack::new();
        stack.push(1);
        stack.push(2);
        stack.push(3);
        assert_eq!(stack.to_string(), "3 -> 2 -> 1");
    }

    #[test]
    fn test_equals() {
        let mut stack1 = Stack::new();
        let mut stack2 = Stack::new();

        assert!(stack1.equals(&stack2));

        stack1.push(1);
        stack1.push(2);

        stack2.push(1);
        stack2.push(2);

        assert!(stack1.equals(&stack2));

        stack2.push(3);

        assert!(!stack1.equals(&stack2));
    }

    #[test]
    fn test_is_empty_and_is_full() {
        let mut stack = Stack::new();
        assert!(stack.is_empty());
        assert!(!stack.is_full());

        stack.push(1);
        assert!(!stack.is_empty());
        assert!(stack.is_full());

        stack.pop();
        assert!(stack.is_empty());
        assert!(!stack.is_full());
    }
}