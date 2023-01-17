window.addEventListener('DOMContentLoaded', (event) => {
    getVisitCount();
});

const functionApi = "https://fnapp-resume-m4hlhzfsttuqg.azurewebsites.net/api/counter/list?code=zZkmpfV1PQ1ug1P8k2Doh0mYOHPUvr3ARPRmCncYc3ALAzFu5W1amA=="

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
