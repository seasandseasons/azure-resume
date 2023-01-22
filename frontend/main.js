window.addEventListener('DOMContentLoaded', (event) => {
    getVisitCount();
});

const functionApi = "https://fnapp-resume-m4hlhzfsttuqg.azurewebsites.net/api/counter/list?code=-nOUKwYmKwhIrYgwPcwbsqIaD292zyL7cwWJKQu_-tJZAzFuQexT2Q==";

const getVisitCount = async () => {
    let count = 30;
    try {
        const response = await fetch(functionApi);
        const jsonResponse = await response.json();
        console.log("Website called function API.");
        count = jsonResponse[0].counter;
        document.getElementById('counter').innerText = count;
    } catch (error) {
        console.log(error);
    }
    return count;
}
