window.addEventListener('DOMContentLoaded', (event) => {
    getVisitCount();
});

const functionApi = ""

const getVisitCount = async () => {
    let count = 30;
    try {
        const response = await fetch(functionApi);
        const jsonResponse = await response.json();
        console.log("Website called function API.");
        count = jsonResponse.counter;
        document.getElementById('counter').innerText = count;
    } catch (error) {
        console.log(error);
    }
    return count;
}
