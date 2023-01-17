window.addEventListener('DOMContentLoaded', (event) => {
    getVisitCount();
});

const functionApi = "https://fnapp-resume-m4hlhzfsttuqg.azurewebsites.net/api/counter/list?code=olCb69dj0A0RM-AEYSkrPfpfOKDUNPogcEW0Q7FKkG0gAzFuR6bNZg==";

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
