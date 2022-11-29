import java.io.IOException;
import java.nio.file.FileSystems;
import java.nio.file.Files;
import java.util.ArrayList;
import java.util.List;
import java.util.Scanner;

class AsciiGenerator {
  private ApiDoc api = new ApiDoc();

  private List<ApiDoc> exceptions = new ArrayList();

  AsciiGenerator() {
    this.read();
    this.save();
  }

  public ApiDoc getApi() {
    return api;
  }

  public void read() {
    final Scanner sc = new Scanner(System.in);

    System.out.print("Enter API title: ");
    this.getApi().setTitle(sc.nextLine());

    System.out.print("Enter API description (Returns a single payment system): ");
    this.getApi().setDescription(sc.nextLine());

    System.out.print("Enter Component name (payment-system): ");
    this.getApi().setComponent(sc.nextLine());

    System.out.print("Enter api name (find-by-id): ");
    this.getApi().setName(sc.nextLine());

    System.out.print("Number of exception documentations: ");
    final int numOfExceptions = sc.nextInt();

    System.out.println("\n\n");
    sc.nextLine();

    for (int i=0; i<numOfExceptions; i++) {
      final ApiDoc exp = new ApiDoc();

      System.out.print("Exception " + (i+1) + "\n");
      System.out.print("Enter Exception name (System Not Found): ");
      exp.setTitle(sc.nextLine());

      System.out.print("Enter Exception description (If the specified item not found then a 404 response will be returned): ");
      exp.setDescription(sc.nextLine());

      System.out.print("Enter Exception name (system-not-found): ");
      exp.setName(sc.nextLine());

      exceptions.add(exp);
    }
  }

  public void print() {
    System.out.print(this.generateAscii());
  }

  public void save() {
    try {
      Files.write(FileSystems.getDefault().getPath("ascii.adoc"), this.generateAscii().getBytes());
//      Files.write(Paths.get("D:\\Workstation\\Production\\Algorithm\\SolveWithJava\\src\\com\\tanvoid0\\lifehacks\\output.txt"), this.generateAscii().getBytes());
    } catch(IOException e) {
      e.printStackTrace();
    }
  }

  public String generateAscii() {
    return "=== " + api.getTitle() + "\n" +
        api.getDescription() + "\n\n" +
        "[[" + api.getComponent() + "-fields]]\n" +
        ".Response Fields\n" +
        api.getDocPath("/response-fields.adoc[]\n") +
        "==== Sample Request\n" +
        api.getDocPath("/http-request.adoc[]\n") +
        "==== Sample Response\n" +
        api.getDocPath("/http-response.adoc[]\n") +
        "==== CURL Sample\n" +
        api.getDocPath("/curl-request.adoc[]\n") +
        "==== Error Responses\n\n" +
        "===== Access Denied\n" +
        "If the user is not authorised to perform the operation then a 403 response will be returned with\n" +
        "a JSON payload containing additional error information, as described in <<error-responses,Error Responses>>.\n\n" +
        "For example: \n" +
        api.getDocPath("/forbidden/http-response.adoc[]\n\n") +
        generateExceptionAscii();
  }

  public String generateExceptionAscii() {
    StringBuilder sb = new StringBuilder();
    this.exceptions.forEach((final ApiDoc item) -> {
      sb
          .append("===== ").append(item.getTitle()).append("\n")
          .append(item.getDescription()).append("\n") // If the specified Delivery Confirmation System is not found then a 404 response will be returned
          .append("with a JSON payload containing additional error information, as described in <<error-responses,Error Responses>>.\n\n")
          .append("For example: \n")
          .append(api.getDocPath("/"+item.getName() + "/http-response.adoc[]\n"));
    });
    return sb.toString();
  }
}

class ApiDoc {
  private String title; // "Get Delivery Confirmation System by ID
  private String description; // Returns a single delivery confirmation system, or an error response if not found.
  private String component; // "delivery-confirmation-system"
  private String name; // "find-by-id"

  public String getDocPath(String subPath) {
    return "include::{snippets}/"+ component +"/" + name + subPath + "\n";
  }

  public String getTitle() {
    return title;
  }

  public void setTitle(String title) {
    this.title = title;
  }

  public String getDescription() {
    return description;
  }

  public void setDescription(String description) {
    this.description = description;
  }

  public String getComponent() {
    return component;
  }

  public void setComponent(String component) {
    this.component = component;
  }

  public String getName() {
    return name;
  }

  public void setName(String name) {
    this.name = name;
  }
}

public class AsciiBuilder {

  public static void main(String[] args) {
    final AsciiGenerator asciiGen = new AsciiGenerator();
  }
}